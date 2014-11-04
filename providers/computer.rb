#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Provider:: computer
# 
# Copyright 2013, Texas A&M
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

require 'mixlib/shellout'

action :create do
  if exists?
    Chef::Log.debug("The object already exists")
    new_resource.updated_by_last_action(false)
  else
    cmd = "dsadd"
    cmd << " computer "
    cmd << dn

    new_resource.options.each do |option, value|
     cmd << " -#{option} #{value}"
     # [-samid SAMName] [-desc Description] [-locLocation] [-memberof GroupDN ...] [{-s Server | -d Domain}] [-uUserName] [-p {Password | *}] [-q] [{-uc | -uco | -uci}]
    end

  execute "Create_#{new_resource.name}" do
    command cmd
  end

  new_resource.updated_by_last_action(true)
  end
end

action :modify do
  if exists?
    cmd = "dsmod"
    cmd << " computer "
    cmd << dn

    new_resource.options.each do |option, value|
      cmd << " -#{option} #{value}"
      # [-desc Description] [-loc Location] [-disabled {yes | no}] [-reset] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}] [-c] [-q] [{-uc | -uco | -uci}] 
    end

    execute "Modify_#{new_resource.name}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The object does not exist")
    new_resource.updated_by_last_action(false)
  end
end

action :move do
  if exists?
    cmd = "dsmove "
    cmd << dn

    new_resource.options.each do |option, value|
      cmd << " -#{option} #{value}"
      # [-newname NewName] [-newparent ParentDN] [{-s Server | -d Domain}] [-u UserName] [-p  {Password | *}] [-q] [{-uc | -uco | -uci}]
    end 

    execute "Move_#{new_resource.name}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The object does not exist")
    new_resource.updated_by_last_action(false)
  end
end

action :delete do
  if exists?
    cmd = "dsrm "
    cmd << dn
    cmd << " -noprompt"

    new_resource.options.each do |option, value|
      cmd << " -#{option} #{value}"
      # [-subtree [-exclude]] [-noprompt] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}][-c][-q][{-uc | -uco | -uci}]
    end 

    execute "Delete_#{new_resource.name}" do
      command cmd
    end  

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("The object has already been removed")
    new_resource.updated_by_last_action(false)  
  end
end

action :join do
  if domain_exists?
    Chef::Log.error("The domain does not exist or was not reachable, please check your network settings")
    new_resource.updated_by_last_action(false)
  else
    if computer_exists?
      Chef::Log.debug("The computer is already joined to the domain")
      new_resource.updated_by_last_action(false)
    else
      powershell_script "join_#{new_resource.name}" do
        if node[:os_version] >= "6.2"
          code <<-EOH
            $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
            $mycreds = New-Object System.Management.Automation.PSCredential  ('#{new_resource.domain_user}', $secpasswd)
            Add-Computer -DomainName #{new_resource.name} -Credential $mycreds -Force:$true -Restart
          EOH
        else
          code "netdom join #{node[:hostname]} /d #{new_resource.name} /ud:#{new_resource.domain_user} /pd:#{new_resource.domain_pass} /reboot"
        end
      end

    new_resource.updated_by_last_action(false)
    end

    new_resource.updated_by_last_action(true)
  end
end

action :unjoin do
  if domain_exists?
    if computer_exists?
      powershell_script "unjoin_#{new_resource.name}" do
        code <<-EOH
        $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
        $mycreds = New-Object System.Management.Automation.PSCredential ('#{new_resource.domain_user}', $secpasswd)
        Remove-Computer -UnjoinDomainCredential $mycreds -Force:$true -Restart
        EOH
      end

      new_resource.updated_by_last_action(true)
	else
      Chef::Log.debug("The computer is already a member of a workgroup")
      new_resource.updated_by_last_action(false)
    end
  else
    Chef::Log.error("The domain does not exist or was not reachable, please check your network settings")
    new_resource.updated_by_last_action(false)
  end
end

def domain_exists?
  ldap_path = new_resource.name.split(".").map! { |k| "dc=#{k}" }.join(",")
  check = Mixlib::ShellOut.new("powershell.exe -command [adsi]::Exists('LDAP://#{ldap_path}')").run_command
  check.stdout.match("True")
end

def computer_exists?
  comp = Mixlib::ShellOut.new("powershell.exe -command \"get-wmiobject -class win32_computersystem -computername . | select domain\"").run_command
  comp.stdout.include?(new_resource.name) or comp.stdout.include?(new_resource.name.upcase)
end

def dn
  dn = "CN=#{new_resource.name},"
  dn << new_resource.ou.split("/").reverse.map { |k| "OU=#{k}" }.join(",") << ","
  dn << new_resource.domain_name.split(".").map! { |k| "DC=#{k}" }.join(",")
end

def exists?
  check = Mixlib::ShellOut.new("dsquery computer -name \"#{new_resource.name}\"").run_command
  check.stdout.include? "DC"
end
