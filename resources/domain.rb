# frozen_string_literal: true

unified_mode true
provides :windows_ad_domain

property :domain_user, String, required: true
property :domain_pass, String, required: true, sensitive: true
property :restart, [true, false], required: true
property :type, String, default: 'forest', equal_to: %w(forest domain replica read-only)
property :safe_mode_pass, String, required: true, sensitive: true
property :options, Hash, default: {}, sensitive: true
property :local_pass, String, sensitive: true
property :replica_type, String, default: 'domain'

action :create do
  unless exists?
    cmd = create_command
    cmd << " -DomainName #{ps_quote(new_resource.name)}"
    cmd << " -SafeModeAdministratorPassword (ConvertTo-SecureString #{ps_quote(new_resource.safe_mode_pass)} -AsPlainText -Force)"
    cmd << ' -Force:$true'
    cmd << ' -NoRebootOnCompletion' unless new_resource.restart
    cmd << format_options(new_resource.options)

    powershell_script "create_domain_#{new_resource.name}" do
      code cmd
      sensitive true
      returns [0, 1, 2, 3, 4]
    end
  end
end

action :delete do
  if exists?
    raise ArgumentError, 'local_pass is required to demote a domain controller' unless new_resource.local_pass

    cmd = +'Uninstall-ADDSDomainController'
    cmd << " -LocalAdministratorPassword (ConvertTo-SecureString #{ps_quote(new_resource.local_pass)} -AsPlainText -Force)"
    cmd << ' -Force:$true -ForceRemoval'
    cmd << ' -DemoteOperationMasterRole' if last_dc?
    cmd << ' -NoRebootOnCompletion' unless new_resource.restart
    cmd << format_options(new_resource.options)

    powershell_script "remove_domain_#{new_resource.name}" do
      code cmd
      sensitive true
    end
  end
end

action_class do
  def ps_quote(value)
    "'#{value.to_s.gsub("'", "''")}'"
  end

  def exists?
    ldap_path = new_resource.name.split('.').map { |part| "DC=#{part}" }.join(',')
    shell_out("powershell.exe -NoProfile -Command [adsi]::Exists(#{ps_quote("LDAP://#{ldap_path}")})").stdout.strip.casecmp('true').zero?
  end

  def last_dc?
    shell_out!('dsquery server -forest').stdout.lines.reject { |line| line.strip.empty? }.size == 1
  end

  def create_command
    cmd = +''
    unless new_resource.type == 'forest'
      cmd << "$secpasswd = ConvertTo-SecureString #{ps_quote(new_resource.domain_pass)} -AsPlainText -Force;"
      cmd << "$mycreds = New-Object System.Management.Automation.PSCredential (#{ps_quote(new_resource.domain_user)}, $secpasswd);"
    end
    cmd << case new_resource.type
           when 'forest' then 'Install-ADDSForest'
           when 'domain' then 'Install-ADDSDomain -Credential $mycreds'
           when 'replica' then 'Install-ADDSDomainController -Credential $mycreds'
           when 'read-only' then 'Add-ADDSReadOnlyDomainControllerAccount -Credential $mycreds'
           end
    cmd
  end

  def format_options(options)
    options.map do |option, value|
      raise ArgumentError, "Invalid ADDS option: #{option}" unless option.to_s.match?(/\A[A-Za-z][A-Za-z0-9]*\z/)

      if value.nil?
        " -#{option}"
      elsif value.is_a?(Numeric) || value.to_s.match?(/\A\((?:Win2003|Win2008|Win2008R2|Win2012|Win2012R2|Default)\)\z/)
        " -#{option} #{value}"
      else
        " -#{option} #{ps_quote(value)}"
      end
    end.join
  end
end
