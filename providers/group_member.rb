#
# Author:: Miguel Ferreira (<miguelferreira@me.com>)
# Cookbook Name:: windows_ad
# Provider:: group_member
# 
# Copyright 2015, Schuberg Philis B.V.
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

require 'mixlib/shellout'

action :add do
  group_dn = dn(new_resource.group_name, new_resource.group_ou, new_resource.domain_name)
  user_dn  = dn(new_resource.user_name,  new_resource.user_ou,  new_resource.domain_name)

  if is_member_of?(user_dn, group_dn)
    Chef::Log.debug("The user is already member of the group")
    new_resource.updated_by_last_action(false)
  else
    execute "Add_user_#{new_resource.user_name}_to_group_#{new_resource.group_name}" do
      command dsmod_group_cmd(group_dn, user_dn, '-addmbr')
    end

    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  group_dn = dn(new_resource.group_name, new_resource.group_ou, new_resource.domain_name)
  user_dn  = dn(new_resource.user_name,  new_resource.user_ou,  new_resource.domain_name)

  if is_member_of?(user_dn, group_dn)
    execute "Remove_user_#{new_resource.user_name}_from_group_#{new_resource.group_name}" do
      command dsmod_group_cmd(group_dn, user_dn, '-rmmbr')
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("User is not a member of the group")
    new_resource.updated_by_last_action(false)
  end
end

def dsmod_group_cmd(group_dn, user_dn, option)
  cmd = "dsmod"
  cmd << " group "
  cmd << "\""
  cmd << group_dn
  cmd << "\""
  cmd << " #{option} "
  cmd << "\""
  cmd << user_dn
  cmd << "\""
end

def dn(name, ou, domain)
  dn = "CN=#{name},"
  if ou.downcase == 'users'
    dn << "CN=#{ou},"
  else
    dn << ou.split("/").reverse.map! { |k| "OU=#{k}" }.join(",")
    dn << ","
  end
  dn << domain.split(".").map! { |k| "DC=#{k}" }.join(",")
end

def is_member_of?(user_dn, group_dn)
  check = Mixlib::ShellOut.new("dsget group  \"#{group_dn}\"  -members").run_command
  check.stdout.include?(user_dn)
end
