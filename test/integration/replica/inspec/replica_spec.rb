#
# Cookbook:: windows_ad
# Spec:: replica
#

# The following are only examples, check out https://github.com/chef/inspec/tree/master/docs
# for everything you can do
describe command('[ADSI]::Exists("LDAP://contoso.local")') do
  its('stdout') { should include 'True' }
end
