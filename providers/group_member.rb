#
# Author:: Miguel Ferreira (<miguelferreira@me.com>)
# Cookbook Name:: windows_ad
# Provider:: group_member
#
# Copyright 2015, Schuberg Philis B.V.

action :add do
  group_dn = CmdHelper.dn(new_resource.group_name, new_resource.group_ou, new_resource.domain_name)
  user_dn  = CmdHelper.dn(new_resource.user_name,  new_resource.user_ou, new_resource.domain_name)

  if member_of?(user_dn, group_dn)
    Chef::Log.debug('The user is already member of the group')
    new_resource.updated_by_last_action(false)
  else
    cmd = dsmod_group_cmd(group_dn, user_dn, '-addmbr')

    Chef::Log.info(print_msg("add #{new_resource.user_name}
                             to #{new_resource.group_name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  group_dn = CmdHelper.dn(new_resource.group_name, new_resource.group_ou, new_resource.domain_name)
  user_dn  = CmdHelper.dn(new_resource.user_name,  new_resource.user_ou, new_resource.domain_name)

  if member_of?(user_dn, group_dn)
    cmd = dsmod_group_cmd(group_dn, user_dn, '-rmmbr')

    Chef::Log.info(print_msg("remove #{new_resource.user_name} from #{new_resource.group_name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error('User is not a member of the group')
    new_resource.updated_by_last_action(false)
  end
end

def dsmod_group_cmd(group_dn, user_dn, option)
  cmd = 'dsmod'
  cmd << ' group '
  cmd << "\""
  cmd << group_dn
  cmd << "\""
  cmd << " #{option} "
  cmd << "\""
  cmd << user_dn
  cmd << "\""
end

def member_of?(user_dn, group_dn)
  check = CmdHelper.shell_out("dsget group  \"#{group_dn}\"  -members", new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
  check.stdout.downcase.include?(user_dn.downcase)
end

def print_msg(action)
  "windows_ad_group_member[#{action}]"
end
