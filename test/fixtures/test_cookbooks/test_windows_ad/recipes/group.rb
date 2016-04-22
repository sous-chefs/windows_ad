user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

windows_ad_group 'Group-temp' do
  action :create
end

windows_ad_group 'Group1' do
  action :create
end

windows_ad_group 'group-temp' do
  action :delete
end

windows_ad_group 'OU-group' do
  action :create
  ou 'Computers'
end
