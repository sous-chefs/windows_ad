include_recipe 'windows_ad::default'

user = 'Administrator'
pass = 'Password1234###!'
domain = 'contoso.local'

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_domain domain do
  type 'forest'
  safe_mode_pass pass
  domain_pass pass
  domain_user user
  action :create
end
