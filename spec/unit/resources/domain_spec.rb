# frozen_string_literal: true

require 'spec_helper'

describe 'windows_ad_domain' do
  step_into :windows_ad_domain
  platform 'windows', '2022'
  let(:present) { false }
  let(:requested_action) { :create }
  let(:domain_type) { 'forest' }

  before do
    allow_any_instance_of(Chef::Provider).to receive(:shell_out).and_return(double(stdout: present ? 'True' : 'False'))
    allow_any_instance_of(Chef::Provider).to receive(:shell_out!).with('dsquery server -forest').and_return(double(stdout: "dc1\n"))
  end

  let(:chef_run) do
    selected_action = requested_action
    selected_type = domain_type
    chef_runner.converge_block do
      windows_ad_domain 'contoso.local' do
        domain_user 'CONTOSO\\Administrator'
        domain_pass "Domain'password"
        safe_mode_pass "Recovery'password"
        local_pass "Local'password"
        restart false
        type selected_type
        action selected_action
      end
    end
  end

  it 'creates a forest without exposing the command or triggering a reboot' do
    expect(chef_run).to run_powershell_script('create_domain_contoso.local')
      .with(sensitive: true, code: "Install-ADDSForest -DomainName 'contoso.local' -SafeModeAdministratorPassword (ConvertTo-SecureString 'Recovery''password' -AsPlainText -Force) -Force:$true -NoRebootOnCompletion")
  end

  { 'domain' => 'Install-ADDSDomain', 'replica' => 'Install-ADDSDomainController', 'read-only' => 'Add-ADDSReadOnlyDomainControllerAccount' }.each do |kind, command|
    context kind do
      let(:domain_type) { kind }

      it 'builds the requested ADDS operation with escaped credentials' do
        script = chef_run.powershell_script('create_domain_contoso.local')
        expect(script.code).to include("ConvertTo-SecureString 'Domain''password'", "#{command} -Credential $mycreds")
        expect(script.sensitive).to be true
      end
    end
  end

  context 'when the domain exists' do
    let(:present) { true }

    it 'does not promote the server again' do
      expect(chef_run).not_to run_powershell_script('create_domain_contoso.local')
    end

    context 'demotion' do
      let(:requested_action) { :delete }

      it 'demotes the final DC with the supplied local password and reboot choice' do
        expect(chef_run).to run_powershell_script('remove_domain_contoso.local')
          .with(sensitive: true, code: "Uninstall-ADDSDomainController -LocalAdministratorPassword (ConvertTo-SecureString 'Local''password' -AsPlainText -Force) -Force:$true -ForceRemoval -DemoteOperationMasterRole -NoRebootOnCompletion")
      end
    end
  end
end
