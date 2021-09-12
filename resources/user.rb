#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook:: windows_ad
# Resource:: user
#
# Copyright:: 2013, Texas A&M

resource_name :windows_ad_user
provides :windows_ad_user

default_action :create

property :domain_name, String, required: true
property :ou, String
property :options, Hash, default: {}
property :reverse, String
property :cmd_user, String
property :cmd_pass, String
property :cmd_domain, String

unified_mode true

action :create do
  if exists?
    Chef::Log.debug('The object already exists')
  else
    Chef::Log.debug("dn is #{dn}")
    cmd = 'dsadd'
    cmd << ' user '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou, new_resource.domain_name)
    cmd << '"'

    Chef::Log.info(print_msg("create #{new_resource.name}"))
    cmd << CmdHelper.cmd_options(new_resource.options)

    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
  end
end

action :modify do
  if exists?
    cmd = 'dsmod'
    cmd << ' user '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou, new_resource.domain_name)
    cmd << '"'
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("modify #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
  else
    Chef::Log.error('The object does not exist')
  end
end

action :move do
  if exists?
    cmd = 'dsmove '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou, new_resource.domain_name)
    cmd << '"'
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("move #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
  else
    Chef::Log.error('The object does not exist')
  end
end

action :delete do
  if exists?
    cmd = 'dsrm '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou, new_resource.domain_name)
    cmd << '"'
    cmd << ' -noprompt'
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("delete #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
  else
    Chef::Log.info('The object has already been removed')
  end
end

action_class do
  def dn
    name = if new_resource.reverse == 'true'
             new_resource.name.split(' ').reverse.map! { |k| k }.join('\\, ')
           else
             new_resource.name
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
    else
      contact = CmdHelper.shell_out("dsquery contact -name \"#{new_resource.name}\"", cmd_user, cmd_pass, cmd_domain)
      user = CmdHelper.shell_out("dsquery user -name \"#{new_resource.name}\"", cmd_user, cmd_pass, cmd_domain)
    end
    contact.stdout.downcase.include?('dc') || user.stdout.downcase.include?('dc')
  end

  def print_msg(action)
    "windows_ad_user[#{action}]"
  end
end
