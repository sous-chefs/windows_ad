require 'mixlib/shellout'

action :join do
  if exists?
	Chef::Log.error("The domain does not exist or was not reachable, please check your network settings")
	new_resource.updated_by_last_action(false)
  else
    powershell "join_#{new_resource.name}" do
      code <<-EOH
	  $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
	  $mycreds = New-Object System.Management.Automation.PSCredential ('#{new_resource.domain_user}', $secpasswd)
	  Add-Computer -DomainName #{new_resource.name} -Credential $mycreds -Force:$true -Restart
	  EOH
    end
	
	new_resource.updated_by_last_action(true)
  end
end

action :unjoin do
  if exists?		
	powershell "unjoin_#{new_resource.name}" do
      code <<-EOH
	  $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
	  $mycreds = New-Object System.Management.Automation.PSCredential ('#{new_resource.domain_user}', $secpasswd)
	  Remove-Computer -DomainName #{new_resource.name} -Credential $mycreds -Force:$true -Restart
	  EOH
    end
	
	new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The domain does not exist or was not reachable, please check your network settings")
	new_resource.updated_by_last_action(false)
  end
end

def exists?
# need method to determine if domain / forest exists
  ldap_path = new_resource.name.split(".").map! { |k| "dc=#{k}" }.join(",")
  check = Mixlib::ShellOut.new("powershell.exe -command [adsi]::Exists('LDAP://#{ldap_path}')").run_command
  check.stdout.match("True")
end