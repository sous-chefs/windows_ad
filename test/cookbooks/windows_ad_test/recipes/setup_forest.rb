# Tests windows_ad::default
# Tests windows_ad::domain - create forest

include_recipe 'windows_ad::default'

windows_ad_domain 'contoso.local' do
  type 'forest'
  safe_mode_pass 'Passw0rd'
  domain_pass 'vagrant'
  domain_user 'Administrator'
  options('InstallDNS': nil)
  action :create
  restart true
  notifies :reboot_now, 'reboot[now]', :immediately
end

reboot 'now' do
  action :nothing
  reason 'Cannot continue Chef run without a reboot.'
  delay_mins 5
  not_if "powershell.exe -command [adsi]::Exists('LDAP://contoso.local')"
end
