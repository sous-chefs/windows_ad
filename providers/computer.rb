require 'mixlib/shellout'

action :add do
  if exists?
    Chef::Log.error("The object already exists")
    new_resource.updated_by_last_action(false)
  else
    cmd = "dsadd"
    cmd << " computer"
	cmd << " cn=#{new_resource.name},"
    cmd << "cn=#{new_resource.ou},"
	cmd << new_resource.domain_name.split(".").map! { |k| "dc=#{k}" }.join(",")
    
	new_resource.options.each do |option, value|
     cmd << " -#{option} #{value}"
    end 
  
  execute "add_#{new_resource.name}" do
    command cmd
  end  
  
  new_resource.updated_by_last_action(true)
  end
end

action :modify do

end

action :move do

end

action :remove do

end

def exists?
  check = Mixlib::ShellOut.new("dsquery #{new_resource.type} -name #{new_resource.name}").run_command
  !check.stdout.match("")
end