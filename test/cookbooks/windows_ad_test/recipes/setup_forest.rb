# Tests windows_ad::default
# Tests windows_ad::domain - create forest

include_recipe 'windows_ad::default'

windows_ad_domain 'contoso.local' do
  type 'forest'
  safe_mode_pass 'Passw0rd'
  domain_pass 'vagrant'
  domain_user 'Administrator'
  case node['os_version']
  when '6.1'
    options('InstallDNS': 'yes')
  when '6.2'
    options('InstallDNS': nil)
  end
  action :create
  restart false
  notifies :reboot_now, 'reboot[now]', :immediate
end

reboot 'now' do
  action :nothing
  reason 'Cannot continue Chef run without a reboot.'
  delay_mins 1
end
