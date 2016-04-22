user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

windows_ad_user 'John Doe' do
  name 'John Doe'
  action :create
  enabled true
  password 'Passw0rd'
  ou 'Users'
  domain_name domain
end

windows_ad_user 'Jane Doe' do
  action :create
  password 'Passw0rd'
  ou 'Users'
  domain_name domain
end
