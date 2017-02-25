describe command("powershell.exe -command \"[adsi]::Exists('LDAP://contoso.local')\"") do
  its(:exit_status) { should eq 0 }
  its('stdout') { should match 'True' }
end