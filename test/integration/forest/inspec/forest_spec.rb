#
# Cookbook:: windows_ad
# Spec:: replica
#

# The following are only examples, check out https://github.com/chef/inspec/tree/master/docs
# for everything you can do
describe command("powershell.exe -command \"[adsi]::Exists('LDAP://contoso.local')\"") do
  its(:exit_status) { should eq 0 }
  its('stdout') { should match 'True' }
end
