#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook:: windows_ad
# Resource:: ou_2012
#
# Copyright:: 2016, Texas A&M

resource_name :windows_ad_ou_2008
provides :windows_ad_ou_2008
unified_mode true

default_action :create

property :domain_name, String
property :ou, String
property :options, Hash, default: {}
property :cmd_user, String
property :cmd_pass, String
property :cmd_domain, String

action :create do
  if parent?
    if exists?
      Chef::Log.debug('The object already exists')
    else
      cmd = 'dsadd'
      cmd << ' ou '
      cmd << '"'
      cmd << dn
      cmd << '"'

      cmd << cmd_options(new_resource.options)

      Chef::Log.info(print_msg("create #{new_resource.name}"))
      CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                          new_resource.cmd_domain)
    end
  else
    Chef::Log.error('The parent OU does not exist')
  end
end

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

action_class do
  def exists?
    dc_partial_dn = CmdHelper.dc_partial_dn(new_resource.domain_name)
    if new_resource.ou.nil?
      ldap = dc_partial_dn
    else
      ldap = CmdHelper.ou_partial_dn(new_resource.ou) << ','
      ldap << dc_partial_dn
    end
    check = CmdHelper.shell_out("dsquery ou -name \"#{new_resource.name}\"",
                                new_resource.cmd_user, new_resource.cmd_pass,
                                new_resource.cmd_domain)
    path = "OU=#{new_resource.name},"
    path << ldap
    check.stdout.downcase.include? path.downcase
  end

  def print_msg(action)
    "windows_ad_ou[#{action}]"
  end
end
