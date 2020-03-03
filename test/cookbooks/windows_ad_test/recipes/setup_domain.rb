# Tests windows_ad::default
# Tests windows_ad::domain - create domain controller

include_recipe 'windows_ad::default'

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
