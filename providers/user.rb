#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Provider:: user
#
# Copyright 2013, Texas A&M

action :create do
  if exists?
    Chef::Log.debug('The object already exists')
    new_resource.updated_by_last_action(false)
  else
    Chef::Log.info("dn is #{dn}")
    cmd = 'dsadd'
    cmd << ' user '
    cmd << "\""
    cmd << dn
    cmd << "\""

    
    Chef::Log.info(print_msg("create #{new_resource.name}"))
    cmd << CmdHelper.cmd_options(new_resource.options)

    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  end
end

action :modify do
  if exists?
    cmd = 'dsmod'
    cmd << ' user '
    cmd << "\""    
    cmd << dn
    cmd << "\""
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("modify #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error('The object does not exist')
    new_resource.updated_by_last_action(false)
  end
end

action :move do
  if exists?
    cmd = 'dsmove '
    cmd << dn

    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("move #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error('The object does not exist')
    new_resource.updated_by_last_action(false)
  end
end

action :delete do
  if exists?
    cmd = 'dsrm '
    cmd << dn
    cmd << ' -noprompt'

    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("delete #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug('The object has already been removed')
    new_resource.updated_by_last_action(false)
  end
end

def dn
  if new_resource.reverse == 'true'
    name = new_resource.name.split(' ').reverse.map! { |k| k }.join('\\, ')
  else
    name = new_resource.name
  end
  CmdHelper.dn(name, new_resource.ou, new_resource.domain_name)
end

def exists?
  cmd_user   = new_resource.cmd_user
  cmd_pass   = new_resource.cmd_pass
  cmd_domain = new_resource.cmd_domain
  if new_resource.reverse == 'true'
    reverse_name = new_resource.name.split(' ').reverse.map! { |k| k }.join(', ')
    contact = CmdHelper.shell_out("dsquery contact -name \"#{reverse_name}\"", cmd_user, cmd_pass, cmd_domain)
    user = CmdHelper.shell_out("dsquery user -name \"#{reverse_name}\"", cmd_user, cmd_pass, cmd_domain)
    contact.stdout.downcase.include?('dc') || user.stdout.downcase.include?('dc')
  else
    contact = CmdHelper.shell_out("dsquery contact -name \"#{new_resource.name}\"", cmd_user, cmd_pass, cmd_domain)
    user = CmdHelper.shell_out("dsquery user -name \"#{new_resource.name}\"", cmd_user, cmd_pass, cmd_domain)
    contact.stdout.downcase.include?('dc') || user.stdout.downcase.include?('dc')
  end
end

def print_msg(action)
  "windows_ad_user[#{action}]"
end
