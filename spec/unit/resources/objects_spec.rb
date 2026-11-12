# frozen_string_literal: true

require 'spec_helper'

%w(contact group user computer).each do |kind|
  describe "windows_ad_#{kind}" do
    step_into "windows_ad_#{kind}".to_sym
    platform 'windows', '2022'

    let(:present) { false }
    let(:requested_action) { :create }
    before do
      allow(CmdHelper).to receive(:shell_out).and_return(double(stdout: present ? 'CN=example,OU=Engineering,DC=contoso,DC=local' : ''))
    end

    let(:chef_run) do
      selected_action = requested_action
      chef_runner.converge_block do
        declare_resource("windows_ad_#{kind}".to_sym, 'example') do
          domain_name 'contoso.local'
          ou 'Engineering'
          options(desc: 'Example object')
          restart false if kind == 'computer'
          action selected_action
        end
      end
    end

    { create: "dsadd #{kind}", modify: "dsmod #{kind}", move: 'dsmove', delete: 'dsrm' }.each do |verb, command|
      context verb.to_s do
        let(:requested_action) { verb }
        let(:present) { verb != :create }

        it 'runs the directory command with the complete DN and options' do
          suffix = verb == :delete ? ' -noprompt' : ''
          expect(CmdHelper).to receive(:shell_out).with("#{command} \"CN=example,OU=Engineering,DC=contoso,DC=local\"#{suffix} -desc \"Example object\"", nil, nil, nil)
          chef_run
        end
      end
    end

    context 'when the object already exists' do
      let(:present) { true }

      it 'does not create the object again' do
        expect(CmdHelper).not_to receive(:shell_out).with(/^dsadd/, anything, anything, anything)
        chef_run
      end
    end

    context 'when deleting an absent object' do
      let(:requested_action) { :delete }

      it 'does not run a deletion command' do
        expect(CmdHelper).not_to receive(:shell_out).with(/^dsrm/, anything, anything, anything)
        chef_run
      end
    end
  end
end
