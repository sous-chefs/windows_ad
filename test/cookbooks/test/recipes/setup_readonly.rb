# frozen_string_literal: true

# Tests windows_ad_features
# Tests windows_ad::domain - create read-only domain controller

windows_ad_features 'default'

user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_domain domain do
  type 'read-only'
  safe_mode_pass pass
  domain_pass pass
  domain_user user
  action :create
end
