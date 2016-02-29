# Tests windows_ad::default
# Tests windows_ad::domain - create forest

include_recipe 'windows_ad::default'

pass = 'Password1234###!'
domain = 'contoso.local'

windows_ad_domain domain do
  safe_mode_pass pass
  case node['os_version']
  when '6.1'
    options ({ 'InstallDNS' => 'yes' })
  when '6.2'
    options ({ 'InstallDNS' => nil })
  end
  action :create
end
