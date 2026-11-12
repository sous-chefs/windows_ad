# frozen_string_literal: true

#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook:: windows_ad
# Resource:: computer
#
# Copyright:: 2013, Texas A&M

resource_name :windows_ad_computer
provides :windows_ad_computer
unified_mode true

default_action :create

property :domain_name, String
property :domain_user, String
property :domain_pass, String, sensitive: true
property :ou, String
property :options, Hash, default: {}
property :cmd_user, String
property :cmd_pass, String, sensitive: true
property :cmd_domain, String
property :restart, [true, false], required: true

action :create do
  if exists?
    Chef::Log.debug('The object already exists')
  else
    cmd = +'dsadd'
    cmd << ' computer '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou,
                        new_resource.domain_name)
    cmd << '"'
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("create #{new_resource.name}"))
    converge_by("update #{new_resource}") do
      CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)
    end
  end
end

action :modify do
  if exists?
    cmd = +'dsmod'
    cmd << ' computer '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou,
                        new_resource.domain_name)
    cmd << '"'
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("modify #{new_resource.name}"))
    converge_by("update #{new_resource}") do
      CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)
    end
  else
    Chef::Log.error('The object does not exist')
  end
end

action :move do
  if exists?
    cmd = +'dsmove '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou,
                        new_resource.domain_name)
    cmd << '"'
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("move #{new_resource.name}"))
    converge_by("update #{new_resource}") do
      CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)
    end
  else
    Chef::Log.error('The object does not exist')
  end
end

action :delete do
  if exists?
    cmd = +'dsrm '
    cmd << '"'
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou,
                        new_resource.domain_name)
    cmd << '"'
    cmd << ' -noprompt'

    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("delete #{new_resource.name}"))
    converge_by("update #{new_resource}") do
      CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)
    end

  else
    Chef::Log.debug('The object has already been removed')
  end
end

action_class do
  def computer_exists?
    comp = shell_out('powershell.exe -command \"get-wmiobject -class win32_computersystem -computername . | select domain\"')
    stdout = comp.stdout.downcase
    Chef::Log.debug("computer_exists? is #{stdout.downcase}")
    stdout.include?(new_resource.domain_name.downcase)
  end

  def exists?
    check = CmdHelper.shell_out("dsquery computer -name \"#{new_resource.name}\"", new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
    check.stdout.downcase.include?(CmdHelper.dn(new_resource.name, new_resource.ou, new_resource.domain_name).downcase)
  end

  def ou_dn
    ou_name = new_resource.ou.split('/').reverse.map { |k| "OU=#{k}" }.join(',') << ','
    ou_name << new_resource.name.split('.').map! { |k| "DC=#{k}" }.join(',')
    check = CmdHelper.shell_out("dsquery computer -name \"#{new_resource.name}\"", new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
    check.stdout.downcase.include?('dc')
  end

  def print_msg(action)
    "windows_ad_contact[#{action}]"
  end
end
