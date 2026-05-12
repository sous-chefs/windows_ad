# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../libraries/cmd_helper'

RSpec.shared_context 'with stubbed command execution' do
  let(:shellout) { instance_double(Mixlib::ShellOut, stdout: '', stderr: '', exitstatus: 0) }

  before do
    allow(CmdHelper).to receive(:shell_out).and_return(shellout)
    allow_any_instance_of(Chef::Resource).to receive(:shell_out).and_return(shellout)
  end
end

describe 'windows_ad_computer' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_computer
  platform 'windows', '2019'

  recipe do
    windows_ad_computer 'workstation1' do
      domain_name 'contoso.local'
      domain_user 'Administrator'
      domain_pass 'Passw0rd'
      restart false
    end
  end

  it { is_expected.to create_windows_ad_computer('workstation1') }
end

describe 'windows_ad_contact' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_contact
  platform 'windows', '2019'

  recipe do
    windows_ad_contact 'Jane Doe' do
      domain_name 'contoso.local'
      ou 'Users'
    end
  end

  it { is_expected.to create_windows_ad_contact('Jane Doe') }
end

describe 'windows_ad_domain' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_domain
  platform 'windows', '2019'

  recipe do
    windows_ad_domain 'contoso.local' do
      type 'forest'
      safe_mode_pass 'Passw0rd'
      restart false
    end
  end

  it { is_expected.to create_windows_ad_domain('contoso.local') }
  it { is_expected.to run_powershell_script('create_domain_contoso.local') }

  it 'treats a missing ADSI domain lookup as absent' do
    expect(CmdHelper).to receive(:shell_out)
      .with(
        "powershell.exe -command \"try { [bool]([adsi]::Exists('LDAP://dc=contoso,dc=local')) } catch { $false }\"",
        nil,
        nil,
        nil
      )
      .and_return(shellout)

    expect(subject).to run_powershell_script('create_domain_contoso.local')
  end
end

describe 'windows_ad_group' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_group
  platform 'windows', '2019'

  recipe do
    windows_ad_group 'Developers' do
      domain_name 'contoso.local'
      ou 'Users'
    end
  end

  it { is_expected.to create_windows_ad_group('Developers') }
end

describe 'windows_ad_group_member' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_group_member
  platform 'windows', '2019'

  recipe do
    windows_ad_group_member 'Jane Doe' do
      group_name 'Developers'
      domain_name 'contoso.local'
      user_ou 'Users'
      group_ou 'Users'
    end
  end

  it { is_expected.to add_windows_ad_group_member('Jane Doe') }
end

describe 'windows_ad_ou' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_ou
  platform 'windows', '2019'

  recipe do
    windows_ad_ou 'Hardware' do
      domain_name 'contoso.local'
    end
  end

  it { is_expected.to create_windows_ad_ou('Hardware') }
  it { is_expected.to create_windows_ad_ou_2012('Hardware') }
end

describe 'windows_ad_ou_2008' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_ou_2008
  platform 'windows', '2019'

  recipe do
    windows_ad_ou_2008 'Legacy' do
      domain_name 'contoso.local'
    end
  end

  it { is_expected.to create_windows_ad_ou_2008('Legacy') }
end

describe 'windows_ad_ou_2012' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_ou_2012
  platform 'windows', '2019'

  recipe do
    windows_ad_ou_2012 'Hardware' do
      domain_name 'contoso.local'
    end
  end

  it { is_expected.to create_windows_ad_ou_2012('Hardware') }
  it { is_expected.to run_powershell_script('create_ou_2012_Hardware') }
end

describe 'windows_ad_user' do
  include_context 'with stubbed command execution'
  step_into :windows_ad_user
  platform 'windows', '2019'

  recipe do
    windows_ad_user 'Jane Doe' do
      domain_name 'contoso.local'
      ou 'Users'
    end
  end

  it { is_expected.to create_windows_ad_user('Jane Doe') }
end
