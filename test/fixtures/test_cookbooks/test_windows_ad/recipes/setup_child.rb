# Tests windows_ad::default
# Tests windows_ad::domain - create child
# Assumes setup_forest suite has been created

include_recipe 'windows_ad::default'

user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'
parent = 'contoso.local'
new_domain = 'child'

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_domain domain do
  type 'domain'
  domain_type 'child'
  safe_mode_pass pass
  domain_pass pass
  domain_user user
  action :create
end
