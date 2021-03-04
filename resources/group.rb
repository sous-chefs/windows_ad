#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook:: windows_ad
# Resource:: group
#
# Copyright:: 2013, Texas A&M

resource_name :windows_ad_group
provides :windows_ad_group

default_action :create

property :domain_name, String
property :ou, String
property :options, Hash, default: {}
property :cmd_user, String
property :cmd_pass, String
property :cmd_domain, String

action :create do
  if exists?
    Chef::Log.debug('The object already exists')
  else
    cmd = 'dsadd'
    cmd << ' group '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou, new_resource.domain_name)
    cmd << '"'
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("create #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
  end
end

action :modify do
  if exists?
    cmd = 'dsmod'
    cmd << ' group '
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
    Chef::Log.debug('The object has already been removed')
  end
end

action_class do
  def dn
    name = new_resource.name
    CmdHelper.dn(name, new_resource.ou, new_resource.domain_name)
  end

  def exists?
    cmd_user   = new_resource.cmd_user
    cmd_pass   = new_resource.cmd_pass
    cmd_domain = new_resource.cmd_domain
    check = CmdHelper.shell_out("dsquery group -name \"#{new_resource.name}\"", cmd_user, cmd_pass, cmd_domain)
    # check = Mixlib::ShellOut.new("dsquery group -name \"#{new_resource.name}\"").run_command
    check.stdout.downcase.include?('dc')
  end

  def print_msg(action)
    "windows_ad_group[#{action}]"
  end
end
