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
    Chef::Log.debug('The object already exists')
    new_resource.updated_by_last_action(false)
  else
    cmd = 'dsadd'
    cmd << ' computer '
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou,
                        new_resource.domain_name)
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("create #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  end
end

action :join do
  unless exists?
    Chef::Log.error('The domain does not exist or was not reachable, please check your network settings')
    new_resource.updated_by_last_action(false)
  else
    if computer_exists?
      Chef::Log.error('The computer is already joined to the domain')
      new_resource.updated_by_last_action(false)
    else
      powershell_script "join_#{new_resource.name}" do
        if node['os_version'] >= '6.2'
          cmd_text = "Add-Computer -DomainName #{new_resource.domain_name} -Credential $mycreds -Force:$true"
          cmd_text << " -OUPath '#{ou_dn}'" if new_resource.ou
          cmd_text << ' -Restart' if new_resource.restart
          code <<-EOH
            $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
            $mycreds = New-Object System.Management.Automation.PSCredential  ('#{new_resource.domain_name}\\#{new_resource.domain_user}', $secpasswd)
            #{cmd_text}
          EOH
        else
          cmd_text = "netdom join #{node['hostname']} /d #{new_resource.domain_name} /ud:#{new_resource.domain_user} /pd:#{new_resource.domain_pass}"
          cmd_text << " /ou:\"#{ou_dn}\"" if new_resource.ou
          cmd_text << ' /reboot' if new_resource.restart
          code cmd_text
        end
      end
      new_resource.updated_by_last_action(true)
    end
  end
end

action :unjoin do
  if computer_exists?
    Chef::Log.debug("Removing computer from the domain")
    powershell_script "unjoin_#{new_resource.domain_name}" do
      if node['os_version'] >= '6.2'
        cmd_text = 'Remove-Computer -UnjoinDomainCredential $mycreds -Force:$true'
        cmd_text << " -ComputerName #{new_resource.name}"
        cmd_text << ' -Restart' if new_resource.restart
      code <<-EOH
        $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
        $mycreds = New-Object System.Management.Automation.PSCredential ('#{new_resource.domain_name}\\#{new_resource.domain_user}', $secpasswd)
        #{cmd_text}
      EOH
    else
      cmd_text = "netdom remove #{new_resource.name}"
      cmd_text << " /d:#{new_resource.domain_name}"
      cmd_text << " /ud:#{new_resource.domain_name}\\#{new_resource.domain_user}"
      cmd_text << " /pd:#{new_resource.domain_pass}"
      cmd_text << ' /reboot' if new_resource.restart
      code cmd_text
    end
  end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error('The computer is not a member of the domain, unable to unjoin.')
    new_resource.updated_by_last_action(false)
  end
end

action :modify do
  if exists?
    cmd = 'dsmod'
    cmd << ' computer '
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou,
                        new_resource.domain_name)
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("modify #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error('The object does not exist')
    new_resource.updated_by_last_action(false)
  end
end

action :move do
  if exists?
    cmd = 'dsmove '
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou,
                        new_resource.domain_name)
    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("move #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error('The object does not exist')
    new_resource.updated_by_last_action(false)
  end
end

action :delete do
  if exists?
    cmd = 'dsrm '
    cmd << CmdHelper.dn(new_resource.name, new_resource.ou,
                        new_resource.domain_name)
    cmd << ' -noprompt'

    cmd << CmdHelper.cmd_options(new_resource.options)

    Chef::Log.info(print_msg("delete #{new_resource.name}"))
    CmdHelper.shell_out(cmd, new_resource.cmd_user, new_resource.cmd_pass,
                        new_resource.cmd_domain)

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug('The object has already been removed')
    new_resource.updated_by_last_action(false)
  end
end

def computer_exists?
  comp = Mixlib::ShellOut.new("powershell.exe -command \"get-wmiobject -class win32_computersystem -computername . | select domain\"").run_command
  stdout = comp.stdout.downcase
  Chef::Log.debug("computer_exists? is #{stdout.downcase}")
  stdout.include?(new_resource.domain_name.downcase)
end

def exists?
  # Supports workstation and server platforms, Windows Server 2008 R2 and Windows 7 share the same version number, Win7 doesnot include netdom command without RSAT.
  if ['os_version'] == '6.1.7600'
    Chef::Log.warn('Unable to determine specific OS version. Windows 7 does not have the native tools to query if the domain exists. Assuming domain exists.')
    return true
  end
  check = Mixlib::ShellOut.new("netdom query /domain:#{new_resource.domain_name} /userD:#{new_resource.domain_user} /passwordd:#{new_resource.domain_pass} dc").run_command
  Chef::Log.debug("netdom query /domain:#{new_resource.domain_name} /userD:#{new_resource.domain_user} /passwordd:#{new_resource.domain_pass} dc")
  Chef::Log.debug("check.stdout.include is #{check.stdout}")
  check.stdout.include? 'The command completed successfully.'
end

def ou_dn
  ou_name = new_resource.ou.split('/').reverse.map { |k| "OU=#{k}" }.join(',') << ','
  ou_name << new_resource.name.split('.').map! { |k| "DC=#{k}" }.join(',')
  check = CmdHelper.shell_out("dsquery computer -name \"#{new_resource.name}\"",
                              new_resource.cmd_user, new_resource.cmd_pass,
                              new_resource.cmd_domain)
  check.stdout.downcase.include?('dc')
end

def print_msg(action)
  "windows_ad_contact[#{action}]"
end
