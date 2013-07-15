require 'mixlib/shellout'

action :join do
  if exists?
	Chef::Log.error("The domain does not exist or was not reachable, please check your network settings")
	new_resource.updated_by_last_action(false)
  else
    if computer_exists?
      Chef::Log.error("The computer is already joined to the domain")
	  new_resource.updated_by_last_action(true)
	else
	  powershell "join_#{new_resource.name}" do
        code <<-EOH
	    $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
	    $mycreds = New-Object System.Management.Automation.PSCredential ('#{new_resource.domain_user}', $secpasswd)
	    Add-Computer -DomainName #{new_resource.name} -Credential $mycreds -Force:$true
	    EOH
	  end
		
	new_resource.updated_by_last_action(true)
	end
  end
end

action :unjoin do
  if computer_exists?		
	powershell "unjoin_#{new_resource.name}" do
      code <<-EOH
	  $secpasswd = ConvertTo-SecureString '#{new_resource.domain_pass}' -AsPlainText -Force
	  $mycreds = New-Object System.Management.Automation.PSCredential ('#{new_resource.domain_user}', $secpasswd)
	  Remove-Computer -UnjoinDomainCredential $mycreds -Force:$true
	  EOH
    end
	
	new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The domain does not exist or was not reachable, please check your network settings")
	new_resource.updated_by_last_action(false)
  end
end

def exists?
  ldap_path = new_resource.name.split(".").map! { |k| "dc=#{k}" }.join(",")
  check = Mixlib::ShellOut.new("powershell.exe -command [adsi]::Exists('LDAP://#{ldap_path}')").run_command
  check.stdout.match("True")
end

def computer_exists?
  comp = Mixlib::ShellOut.new("powershell.exe -command \"get-wmiobject -class win32_computersystem -computername . | select domain\"").run_command
  comp.stdout.match("#{new_resource.name}")
end