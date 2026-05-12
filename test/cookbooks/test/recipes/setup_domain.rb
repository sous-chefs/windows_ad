# frozen_string_literal: true

# Tests windows_ad_features
# Tests windows_ad::domain - create domain controller

windows_ad_features 'default'

user = 'Administrator'
pass = 'Passw0rd'
domain = 'www.contoso.local'

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_domain domain do
  type 'domain'
  safe_mode_pass pass
  domain_pass pass
  domain_user user
  action :create
  restart false
  notifies :reboot_now, 'reboot[now]', :immediately
end

reboot 'now' do
  action :nothing
  reason 'Cannot continue Chef run without a reboot.'
  delay_mins 1
end
