# frozen_string_literal: true

title 'windows_ad forest'

control 'windows-ad-forest-01' do
  impact 1.0
  title 'contoso.local forest exists'

  describe command('[ADSI]::Exists("LDAP://contoso.local")') do
    its('stdout') { should include 'True' }
  end
end
