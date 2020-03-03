# InSpec test for recipe windows_ad_test::setup_forest

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe command('[ADSI]::Exists("LDAP://contoso.local")') do
  its('stdout') { should include 'True' }
end
