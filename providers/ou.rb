require 'mixlib/shellout'

action :add do
  if exists?
    Chef::Log.error("The object already exists")
    new_resource.updated_by_last_action(false)
  else
    cmd = "dsadd"
    cmd << " ou "
	cmd << dn
    
	new_resource.options.each do |option, value|
     cmd << " -#{option} #{value}"
	 # [-desc Description] [{-s Server | -d Domain}][-u UserName] [-p {Password | *}] [-q] [{-uc | -uco | -uci}]
    end 
  
    execute "add_#{new_resource.name}" do
      command cmd
    end  
  
  new_resource.updated_by_last_action(true)
  end
end

action :modify do
  if exists?
    cmd = "dsmod"
    cmd << " ou "
	cmd << dn
    
	new_resource.options.each do |option, value|
      cmd << " -#{option} #{value}"
	  # [-desc Description] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}][-c] [-q] [{-uc | -uco | -uci}]
    end 

    execute "modify_#{new_resource.name}" do
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
  
    execute "move_#{new_resource.name}" do
      command cmd
    end  
	
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The object does not exist")
	new_resource.updated_by_last_action(false)
  end
end

action :remove do
  if exists?
    cmd = "dsrm "
    cmd << dn
	cmd << " -noprompt"
    
	new_resource.options.each do |option, value|
      cmd << " -#{option} #{value}"
	  # [-subtree [-exclude]] [-noprompt] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}][-c][-q][{-uc | -uco | -uci}]
    end 
  
    execute "remove_#{new_resource.name}" do
      command cmd
    end  
	
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The object has already been removed")
    new_resource.updated_by_last_action(false)  
  end
end

def dn
  dn = "ou=#{new_resource.name},"
  if new_resource.ou.nil?
  else
    dn << new_resource.ou.split("/").reverse.map! { |k| "ou=#{k}" }.join(",")
	dn << ","
  end
  dn << new_resource.domain_name.split(".").map! { |k| "dc=#{k}" }.join(",")
end

def exists?
  if new_resource.ou.nil?
  else
    ldap = "OU=#{new_resource.ou},"
    ldap << new_resource.domain_name.split(".").map! { |k| "DC=#{k}" }.join(",")
  end
  check = Mixlib::ShellOut.new("dsquery ou -name #{new_resource.name}").run_command
  path = "OU=#{new_resource.name},"
  path << ldap
  check.stdout.include? path
end