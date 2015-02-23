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

action :add do
  group_dn = CmdHelper.dn(new_resource.group_name, new_resource.group_ou, new_resource.domain_name)
  user_dn  = CmdHelper.dn(new_resource.user_name,  new_resource.user_ou,  new_resource.domain_name)

  if is_member_of?(user_dn, group_dn)
    Chef::Log.debug("The user is already member of the group")
    new_resource.updated_by_last_action(false)
  else
    cmd = dsmod_group_cmd(group_dn, user_dn, '-addmbr')

    Chef::Log.info(print_msg("add #{new_resource.user_name} to #{new_resource.group_name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  group_dn = CmdHelper.dn(new_resource.group_name, new_resource.group_ou, new_resource.domain_name)
  user_dn  = CmdHelper.dn(new_resource.user_name,  new_resource.user_ou,  new_resource.domain_name)

  if is_member_of?(user_dn, group_dn)
    cmd = dsmod_group_cmd(group_dn, user_dn, '-rmmbr')

    Chef::Log.info(print_msg("remove #{new_resource.user_name} from #{new_resource.group_name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)

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

def is_member_of?(user_dn, group_dn)
  check = CmdHelper.shell_out("dsget group  \"#{group_dn}\"  -members",
                              new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
  check.stdout.downcase.include?(user_dn.downcase)
end

def print_msg(action)
  "windows_ad_group_member[#{action}]"
end
