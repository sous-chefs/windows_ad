user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

windows_ad_computer 'localhost' do
  action :unjoin
  domain_name domain
  domain_user user
  domain_pass pass
end
