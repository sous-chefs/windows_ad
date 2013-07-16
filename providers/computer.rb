action :add do
  cmd = ::WinADObject.new
    
    cmd << " cn=#{new_resource.name},"
    cmd << ldappath
	cmd << options
    
  execute "add_#{new_resource.name}" do
    command cmd
  end  
    
end

action :modify do

end

action :move do

end

action :remove do

end