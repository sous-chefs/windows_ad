# frozen_string_literal: true

require 'spec_helper'

describe 'windows_ad_ou_2008' do
  step_into :windows_ad_ou_2008
  platform 'windows', '2022'

  before do
    allow(CmdHelper).to receive(:shell_out).and_return(double(stdout: ''))
  end

  recipe do
    windows_ad_ou_2008 'Engineering' do
      domain_name 'contoso.local'
      options(desc: 'Engineering team')
    end
  end

  it 'retains the public dsadd provider name and executes creation' do
    expect(CmdHelper).to receive(:shell_out).with('dsadd ou "ou=Engineering,DC=contoso,DC=local" -desc "Engineering team"', nil, nil, nil)
    chef_run
  end
end

%i(windows_ad_ou windows_ad_ou_2012).each do |resource_type|
  describe resource_type.to_s do
    step_into :windows_ad_ou, :windows_ad_ou_2012
    platform 'windows', '2022'

    let(:present) { false }
    before do
      allow(CmdHelper).to receive(:shell_out).and_return(double(stdout: present ? 'True' : 'False'))
    end

    recipe do
      declare_resource(resource_type, 'Engineering') do
        domain_name 'contoso.local'
      end
    end

    it 'creates the OU at the domain root with a complete path' do
      expect(chef_run).to run_powershell_script('create_ou_2012_Engineering')
        .with(code: 'New-ADOrganizationalUnit -Name "Engineering" -Path "DC=contoso,DC=local"')
    end

    context 'when present' do
      let(:present) { true }

      it 'does not create the OU again' do
        expect(chef_run).not_to run_powershell_script('create_ou_2012_Engineering')
      end
    end
  end
end
