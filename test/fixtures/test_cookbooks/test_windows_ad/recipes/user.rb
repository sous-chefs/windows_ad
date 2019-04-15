user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.com'

windows_ad_user 'John Doe' do
  name 'John Doe'
  action :create
  ou 'Users'
  domain_name domain
end

windows_ad_user 'Jane Doe' do
  action :create
  ou 'Users'
  domain_name domain
end

windows_ad_user 'John Doe' do
  action :delete
end
