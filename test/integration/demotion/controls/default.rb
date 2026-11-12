# frozen_string_literal: true

control 'demoted-server' do
  impact 1.0
  title 'The server is no longer a domain controller'
  desc 'Verify the disposable forest lifecycle finishes on a member or standalone server.'

  describe command('(Get-CimInstance Win32_ComputerSystem).DomainRole') do
    its('exit_status') { should eq 0 }
    its('stdout.strip') { should match(/\A[0-3]\z/) }
  end
end
