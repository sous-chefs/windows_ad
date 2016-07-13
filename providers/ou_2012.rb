#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Provider:: ou_2012
#
# Copyright 2013, Texas A&M

action :create do
  if exists?
    Chef::Log.info('The object already exists')
    new_resource.updated_by_last_action(false)
  else
    cmd = 'New-ADOrganizationalUnit'
    cmd << " -Name \"#{new_resource.name}\""
    cmd << " -Path \"#{dn}\"" unless new_resource.path.nil?
  
    powershell_script "create_ou_2012_#{new_resource.name}" do
      code cmd
    end
    Chef::Log.info('The object has been created')
    new_resource.updated_by_last_action(true)
  end
end

def dn
  unless new_resource.path.nil?
    dn = ""
    dn << CmdHelper.ou_partial_dn(new_resource.path) << ','
  end
  dn << CmdHelper.dc_partial_dn(new_resource.domain_name)
end

def exists?
  dc_partial_dn = CmdHelper.dc_partial_dn(new_resource.domain_name)
  if new_resource.path.nil?
    ldap = dc_partial_dn
  else    
    ldap = CmdHelper.ou_partial_dn(new_resource.path) << ','
    ldap << dc_partial_dn
  end
  path = "OU=#{new_resource.name},"
  path = path.gsub('/','\/') if path.include?('/')
  path << ldap
  Chef::Log.info("path is #{path}")
  check = CmdHelper.shell_out("powershell.exe \"[adsi]::Exists('LDAP://#{path}')\"", new_resource.cmd_user, new_resource.cmd_pass, new_resource.cmd_domain)
  check.stdout.downcase.include?("true")
end
  