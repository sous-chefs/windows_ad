domain = 'contoso.local'

windows_ad_user 'John Doe' do
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
  ou 'Users'
  domain_name domain
end
