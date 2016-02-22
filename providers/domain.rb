#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Provider:: domain
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

ENUM_NAMES = %w{(Win2003) (Win2008) (Win2008R2) (Win2012) (Win2012R2) (Default)}

action :create do
  if exists?
    new_resource.updated_by_last_action(false)
  else
    if node['os_version'] >= '6.2'
      cmd = create_command
      cmd << " -DomainName #{new_resource.name}"
      cmd << " -SafeModeAdministratorPassword (convertto-securestring '#{new_resource.safe_mode_pass}' -asplaintext -Force)"
      cmd << ' -Force:$true'
    else node[:os_version] <= '6.1'
      cmd = 'dcpromo -unattend'
      cmd << " -newDomain:#{new_resource.type}"
      cmd << " -NewDomainDNSName:#{new_resource.name}"
      cmd << ' -RebootOnCompletion:Yes'
      cmd << " -SafeModeAdminPassword:(convertto-securestring '#{new_resource.safe_mode_pass}' -asplaintext -Force)"
      cmd << " -ReplicaOrNewDomain:#{new_resource.replica_type}"
    end

	cmd << format_options(new_resource.options)
	
    powershell_script "create_domain_#{new_resource.name}" do
      code cmd
      returns [0, 1, 2, 3, 4]
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  Chef::Log.warn('This version of Windows Server is currently unsupported
                  beyond installing the required roles and features. Help us
                  out by submitting a pull request.') if ['os_version'] <= '6.1'
  if exists?
    cmd = 'Uninstall-ADDSDomainController'
    cmd << " -LocalAdministratorPassword (ConverTTo-SecureString '#{new_resource.local_pass}' -AsPlainText -Force)"
    cmd << ' -Force:$true'
    cmd << ' -ForceRemoval'
    cmd << ' -DemoteOperationMasterRole' if last_dc?
    cmd << format_options(new_resource.options)

    powershell_script "remove_domain_#{new_resource.name}" do
      code cmd
    end

    new_resource.updated_by_last_action(true)
  else
    new_resource.updated_by_last_action(false)
  end
end

action :join do
  unless exists?
    Chef::Log.error('The domain does not exist or was not reachable, please check your network settings')
    new_resource.updated_by_last_action(false)
  else
    if computer_exists?
      Chef::Log.debug('The computer is already joined to the domain')
      new_resource.updated_by_last_action(false)
    else
      powershell_script "join_#{new_resource.name}" do
        if node[:os_version] >= '6.2'
          cmd_text = "Add-Computer -DomainName #{new_resource.name} -Credential $mycreds -Force:$true"
          cmd_text << " -OUPath '#{ou_dn}'" if new_resource.ou
          cmd_text << ' -Restart' if new_resource.restart
          code <<-EOH
            $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
            $mycreds = New-Object System.Management.Automation.PSCredential  ('#{new_resource.name}\\#{new_resource.domain_user}', $secpasswd)
            #{cmd_text}
          EOH
        else
          cmd_text = "netdom join #{node[:hostname]} /d #{new_resource.name} /ud:#{new_resource.domain_user} /pd:#{new_resource.domain_pass}"
          cmd_text << " /ou:\"#{ou_dn}\"" if new_resource.ou
          cmd_text << ' /reboot' if new_resource.restart
          code "#{cmd_text}"
        end
      end
      new_resource.updated_by_last_action(true)
    end
  end
end

action :unjoin do
  if computer_exists?
    powershell_script "unjoin_#{new_resource.name}" do
      cmd_text = 'Remove-Computer -UnjoinDomainCredential $mycreds -Force:$true'
      cmd_text << ' -Restart' if new_resource.restart
      code <<-EOH
        $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
        $mycreds = New-Object System.Management.Automation.PSCredential ('#{new_resource.name}\\#{new_resource.domain_user}', $secpasswd)
        #{cmd_text}
      EOH
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug('The computer is already a member of a workgroup')
    new_resource.updated_by_last_action(false)
  end
end

def ou_dn
  ou_name = new_resource.ou.split('/').reverse.map { |k| "OU=#{k}" }.join(',') << ','
  ou_name << new_resource.name.split('.').map! { |k| "DC=#{k}" }.join(',')
end

def exists?
  ldap_path = new_resource.name.split('.').map! { |k| "dc=#{k}" }.join(',')
  check = Mixlib::ShellOut.new("powershell.exe -command [adsi]::Exists('LDAP://#{ldap_path}')").run_command
  check.stdout.match('True')
end

def computer_exists?
  comp = Mixlib::ShellOut.new("powershell.exe -command \"get-wmiobject -class win32_computersystem -computername . | select domain\"").run_command
  stdout = comp.stdout.downcase
  stdout.include?(new_resource.name.downcase)
end

def last_dc?
  dsquery = Mixlib::ShellOut.new('dsquery server -forest').run_command
  dsquery.stdout.split("\n").size == 1
end

def create_command
  if node['os_version'] > '6.2'
    cmd = ''
    if new_resource.type != 'forest'
      cmd << "$secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force;"
      cmd << "$mycreds = New-Object System.Management.Automation.PSCredential  ('#{new_resource.domain_user}', $secpasswd);"
    end
    case new_resource.type
    when 'forest'
      cmd << 'Install-ADDSForest'
    when 'domain'
      cmd << 'Install-ADDSDomain -Credential $mycreds'
    when 'replica'
      cmd << 'Install-ADDSDomainController -Credential $mycreds'
    when 'read-only'
      cmd << 'Add-ADDSReadOnlyDomainControllerAccount -Credential $mycreds'
    end
  else
    case new_resource.type
    when 'forest'
      'forest'
    when 'domain'
      'domain'
    when 'read-only'
      'domain'
    when 'replica'
      'replica'
    end
  end
end

def format_options(options)
  options.reduce('') do |cmd, (option, value)|
    if value.nil?
      cmd << " -#{option}"
    elsif ENUM_NAMES.include?(value) || value.is_a?(Numeric)
      if node['os_version'] >= '6.2'
        cmd << " -#{option} #{value}"
      else
        cmd << " -#{option}:#{value}"
      end
    else
      if node['os_version'] >= '6.2'
        cmd << " -#{option} '#{value}'"
      else
        cmd << " -#{option}:'#{value}'"
      end
    end
  end
end
