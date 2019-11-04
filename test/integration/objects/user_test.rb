# InSpec test for recipe windows_ad_test::user

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe command('(Get-ADUser -Identity \'Jane Doe\').name -eq "Jane Doe"') do
  its('stdout') { should include 'True' }
end
