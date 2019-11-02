# InSpec test for recipe windows_ad_test::group

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe command('(powershell.exe Get-ADGroup -Identity Group1).name -eq "Group1"') do
  its('stdout') { should include 'True' }
end
  
describe command('(powershell.exe Get-ADGroup -Identity OU-Group).name -eq "OU-Group"') do
  its('stdout') { should include 'True' }
end
