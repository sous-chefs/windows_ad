user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

windows_ad_ou 'Hardware' do
  action :create
  domain_name domain
end

windows_ad_ou 'Sub OU' do
  action :create
  ou 'Hardware'
  domain_name domain
end
