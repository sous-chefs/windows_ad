# frozen_string_literal: true

title 'windows_ad objects'

control 'windows-ad-ou-01' do
  impact 1.0
  title 'Organizational units exist'

  describe command('[ADSI]::Exists("LDAP://ou=hardware,dc=contoso,dc=local")') do
    its('stdout') { should include 'True' }
  end

  describe command('[ADSI]::Exists("LDAP://ou=sub ou,ou=hardware,dc=contoso,dc=local")') do
    its('stdout') { should include 'True' }
  end
end

control 'windows-ad-group-01' do
  impact 1.0
  title 'Groups exist'

  describe command('(Get-ADGroup -Identity Group1).name -eq "Group1"') do
    its('stdout') { should include 'True' }
  end

  describe command('(Get-ADGroup -Identity OU-Group).name -eq "OU-Group"') do
    its('stdout') { should include 'True' }
  end
end

control 'windows-ad-user-01' do
  impact 1.0
  title 'Users exist'

  describe command('(Get-ADUser -Identity \'Jane Doe\').name -eq "Jane Doe"') do
    its('stdout') { should include 'True' }
  end
end
