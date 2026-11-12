# frozen_string_literal: true

require 'spec_helper'

describe 'windows_ad_group_member' do
  step_into :windows_ad_group_member
  platform 'windows', '2022'
  let(:present) { false }
  let(:requested_action) { :add }

  before do
    allow(CmdHelper).to receive(:shell_out).and_return(double(stdout: present ? 'CN=alice,CN=Users,DC=contoso,DC=local' : ''))
  end

  let(:chef_run) do
    selected_action = requested_action
    chef_runner.converge_block do
      windows_ad_group_member 'alice' do
        group_name 'developers'
        user_ou 'Users'
        group_ou 'Engineering'
        domain_name 'contoso.local'
        action selected_action
      end
    end
  end

  it 'adds the user DN to the group DN' do
    expect(CmdHelper).to receive(:shell_out).with('dsmod group "CN=developers,OU=Engineering,DC=contoso,DC=local" -addmbr "CN=alice,CN=Users,DC=contoso,DC=local"', nil, nil, nil)
    chef_run
  end

  context 'when already a member' do
    let(:present) { true }

    it 'does not add the user again' do
      expect(CmdHelper).not_to receive(:shell_out).with(/^dsmod/, anything, anything, anything)
      chef_run
    end

    context 'removal' do
      let(:requested_action) { :remove }

      it 'removes the user DN from the group DN' do
        expect(CmdHelper).to receive(:shell_out).with('dsmod group "CN=developers,OU=Engineering,DC=contoso,DC=local" -rmmbr "CN=alice,CN=Users,DC=contoso,DC=local"', nil, nil, nil)
        chef_run
      end
    end
  end
end
