# Tests windows_ad::default
# Tests windows_ad::domain - create forest

include_recipe 'windows_ad::default'

user = 'Administrator'
pass = 'Password1234###!'
domain = 'contoso.local'

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_domain domain do
  type 'forest'
  safe_mode_pass pass
  netbios_name 'contoso'
  domain_pass pass
  domain_user user
  action :create
end
