# InSpec test for recipe windows_ad_test::ou

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe command('[ADSI]::Exists("LDAP://ou=hardware,dc=contoso,dc=local")') do
  its('stdout') { should include 'True' }
end

describe command('[ADSI]::Exists("LDAP://ou=sub ou,ou=hardware,dc=contoso,dc=local")') do
  its('stdout') { should include 'True' }
end
