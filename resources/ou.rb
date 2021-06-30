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
  if exists?
    Chef::Log.info('The object already exists')
  else
    cmd = 'New-ADOrganizationalUnit'
    cmd << " -Name \"#{new_resource.name}\""
    cmd << " -Path \"#{dn}\"" unless new_resource.path.nil?

    powershell_script "create_ou_2012_#{new_resource.name}" do
      code cmd
    end
    Chef::Log.info('The object has been created')
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
