include_recipe 'windows_ad::default'

user = 'Administrator'
pass = 'Passw0rd'
domain = "contoso.local"

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_domain domain do
  type           'forest'
  safe_mode_pass pass
  domain_pass    pass
  domain_user    user
  case node['os_version']
  when '6.1'
    options ({ 'InstallDNS' => 'yes' })
  when '6.2'
    options ({ 'InstallDNS' => nil })
  end
  action :create
end
