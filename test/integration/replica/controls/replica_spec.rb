# frozen_string_literal: true

title 'windows_ad replica'

control 'windows-ad-replica-01' do
  impact 1.0
  title 'contoso.local is available'

  describe command('[ADSI]::Exists("LDAP://contoso.local")') do
    its('stdout') { should include 'True' }
  end
end
