#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Recipe:: contoso
# 
# Copyright 2013, Texas A&M
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# This is provided as a sample recipe to get you up and going with the windows_ad cookbook.

include_recipe 'windows_ad::default'

windows_ad_domain 'contoso.com' do
  action :create
  type 'forest'
  safe_mode_pass 'Passw0rd'
end

#set adminitrator password to Passw0rd
execute 'Set Administrator Password' do
  command 'net user Administrator Passw0rd'
end

windows_ad_ou 'AD' do
  domain_name 'contoso.com'
  action :create
end

windows_ad_ou 'Groups' do
  domain_name 'contoso.com'
  ou          'AD'
  action :create
end

windows_ad_ou 'SubGroups' do
  domain_name 'contoso.com'
  ou          'AD/Groups'
  action :create
end

windows_ad_group 'Group1' do
  domain_name 'contoso.com'
  ou 'AD/Groups'
  action :create
end

windows_ad_user 'User1' do
  domain_name 'contoso.com'
  ou 'Users'
  options ({
    'pwd' => 'Passw0rd'
  })
  action :create
end

windows_ad_user 'User2' do
  domain_name 'contoso.com'
  ou 'Users'
  options ({
    'pwd' => 'Passw0rd'
  })
  action :create
end

windows_ad_group_member 'User1' do
  domain_name 'contoso.com'
  group_name 'Group1'
  user_ou  'Users'
  group_ou 'AD/Groups'
  action :add
end

windows_ad_group_member 'User2' do
  domain_name 'contoso.com'
  group_name 'Group1'
  user_ou  'Users'
  group_ou 'AD/Groups'
  action :add
end

windows_ad_group_member 'User1' do
  domain_name 'contoso.com'
  group_name 'Group1'
  user_ou  'Users'
  group_ou 'AD/Groups'
  action :remove
end
