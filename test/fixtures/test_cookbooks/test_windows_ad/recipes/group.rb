user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

windows_ad_group 'Group temp' do
  action :create
  ou 'Hardware/Sub OU'
  domain_name domain
end

windows_ad_group 'Group1' do
  action :create
  ou 'Hardware'
  domain_name domain
end

windows_ad_group 'Group temp' do
  action :delete
  ou 'Hardware/Sub OU'
  domain_name domain
end

windows_ad_group 'OU-group' do
  action :create
  ou 'Hardware'
  domain_name domain
end
