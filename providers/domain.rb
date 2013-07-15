## TODO: seperate secure string func
require 'mixlib/shellout'

action :create do
  if exists?
    new_resource.updated_by_last_action(false)
  else
    cmd = create_command
    cmd << " -DomainName #{new_resource.name}"
    cmd << " -SafeModeAdministratorPassword (convertto-securestring '#{new_resource.safe_mode_pass}' -asplaintext -Force)"
    cmd << " -Force:$true"
    
    new_resource.options.each do |option, value|
      if value.nil?
        cmd << " -#{option}"
      else
        cmd << " -#{option} '#{value}'"
      end
    end 
	
    powershell "create_domain_#{new_resource.name}" do
      code cmd
    end
  
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if exists?
    cmd = "Uninstall-ADDSDomainController"
	cmd << " -LocalAdministratorPassword (ConverTTo-SecureString '#{new_resource.local_pass}' -AsPlainText -Force)"
	cmd << " -Force:$true"
	cmd << " -ForceRemoval"
    if last_dc?
	  cmd << " -DemoteOperationMasterRole"
	end	  
    
    new_resource.options.each do |option, value|
      if value.nil?
        cmd << " -#{option}"
      else
        cmd << " -#{option} '#{value}'"
      end
    end 	

    powershell "remove_domain_#{new_resource.name}" do
      code cmd
    end  
	
	new_resource.updated_by_last_action(true)
  else
	new_resource.updated_by_last_action(false)
  end
end

def create_command
  case new_resource.type
  when "forest"
    "Install-ADDSForest"
  when "domain"
    "install-ADDSDomain"
  when "replica", "DC"
    "Install-ADDSDomainController"
  when "read-only", "RO"
    "Add-ADDSReadOnlyDomainControllerAccount"
  end
end

def exists?
  ldap_path = new_resource.name.split(".").map! { |k| "dc=#{k}" }.join(",")
  check = Mixlib::ShellOut.new("powershell.exe -command [adsi]::Exists('LDAP://#{ldap_path}')").run_command
  check.stdout.match("True")
end

def last_dc?
  dsquery = Mixlib::ShellOut.new("dsquery server -forest").run_command
  dsquery.stdout.split("\n").size == 1
end
