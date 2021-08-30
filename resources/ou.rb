#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook:: windows_ad
# Resource:: ou
#
# Copyright:: 2013, Texas A&M

resource_name :windows_ad_ou
provides :windows_ad_ou

default_action :create

property :domain_name, String
property :ou, String
property :options, Hash, default: {}
property :cmd_user, String
property :cmd_pass, String
property :cmd_domain, String

unified_mode true

action :create do
  require 'chef/win32/version'
  win_ver = Chef::ReservedNames::Win32::Version.new
  if win_ver.windows_server_2008? || win_ver.windows_server_2008_r2?
    windows_ad_ou_2008 new_resource.name do
      action :create
      ou new_resource.ou unless new_resource.ou.nil?
      domain_name new_resource.domain_name
    end
  elsif Chef::Version.new(node['os_version']) >= Chef::Version.new('6.2')
    windows_ad_ou_2012 new_resource.name do
      action :create
      path new_resource.ou unless new_resource.ou.nil?
      domain_name new_resource.domain_name
    end
  else
    Chef::Log.error('This version of Windows is not supported')
  end
end

action :modify do
  if exists?
    cmd = 'dsmod'
    cmd << ' ou '
    cmd << '"'
    cmd << dn.to_s
    cmd << '"'
    cmd << cmd_options(new_resource.options)

    Chef::Log.info(print_msg("modify #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)
  else
    Chef::Log.error('The object does not exist')
  end
end

action :move do
  if exists?
    cmd = 'dsmove '
    cmd << '"'
    cmd << dn.to_s
    cmd << '"'
    cmd << cmd_options(new_resource.options)

    Chef::Log.info(print_msg("move #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)
  else
    Chef::Log.error('The object does not exist')
  end
end

action :delete do
  if exists?
    cmd = 'dsrm '
    cmd << '"'
    cmd << dn.to_s
    cmd << '"'
    cmd << ' -noprompt'

    cmd << cmd_options(new_resource.options)

    Chef::Log.info(print_msg("delete #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)
  else
    Chef::Log.debug('The object has already been removed')
  end
end

action_class do
  def cmd_options(options)
    cmd = ''
    options.each do |option, value|
      cmd << " -#{option} \"#{value}\""
      # [-subtree [-exclude]] [-noprompt] [{-s Server | -d Domain}] [-u UserName]
      # [-p {Password | *}][-c][-q][{-uc | -uco | -uci}]
    end
    cmd
  end

  def dn
    dn = "ou=#{new_resource.name},"
    unless new_resource.ou.nil?
      dn << CmdHelper.ou_partial_dn(new_resource.ou) << ','
    end
    dn << CmdHelper.dc_partial_dn(new_resource.domain_name)
  end

  def parent?
    if new_resource.ou.nil?
      true
    else
      ldap = CmdHelper.dc_partial_dn(new_resource.domain_name)
      parent_ou_name = CmdHelper.ou_leaf(new_resource.ou)
      parent = CmdHelper.shell_out("dsquery ou -name \"#{parent_ou_name}\"",
                                   new_resource.cmd_user, new_resource.cmd_pass,
                                   new_resource.cmd_domain)
      path = CmdHelper.ou_partial_dn(new_resource.ou) << ','
      path << ldap
      parent.stdout.downcase.include? path.downcase
    end
  end

  def exists?
    dc_partial_dn = CmdHelper.dc_partial_dn(new_resource.domain_name)
    if new_resource.ou.nil?
      ldap = dc_partial_dn
    else
      ldap = CmdHelper.ou_partial_dn(new_resource.ou) << ','
      ldap << dc_partial_dn
    end
    check = CmdHelper.shell_out("dsquery ou -name \"#{new_resource.name}\"", new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
    path = "OU=#{new_resource.name},"
    path << ldap
    check.stdout.downcase.include? path.downcase
  end

  def print_msg(action)
    "windows_ad_ou[#{action}]"
  end
end
