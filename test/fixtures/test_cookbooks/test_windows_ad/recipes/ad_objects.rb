windows_ad_ou 'AD' do
  domain_name domain
  action :create
end

windows_ad_ou 'Groups' do
  domain_name domain
  ou 'AD'
  action :create
end

windows_ad_ou 'SubGroups' do
  domain_name domain
  ou 'AD/Groups'
  action :create
end

windows_ad_group 'Group1' do
  domain_name domain
  on 'AD/Groups'
  action :create
end

windows_ad_user 'User1' do
  domain_name domain
  ou 'Users'
  options ({
    'pwd' => pass
  })
  action :create
end

windows_ad_user 'User2' do
  domain_name domain
  ou 'Users'
  options ({
    'pwd' => pass
  })
  action :create
end

windows_ad_group_member 'User1' do
  domain_name domain
  group_name 'Group1'
  user_ou 'Users'
  group_ou 'AD/Groups'
  action :add
end

windows_ad_group_member 'User2' do
  domain_name domain
  group_name 'Group1'
  user_ou 'Users'
  group_ou 'AD/Groups'
  action :add
end

windows_ad_group_member 'Users1' do
  domain_name domain
  group_name 'Group1'
  user_ou 'Users'
  groups_ou 'AD/Groups'
  action :remove
end
