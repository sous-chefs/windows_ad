require 'mixlib/shellout'

module Chef
  module Helper
    module WinADObject
      def exists?
        check = Mixlib::ShellOut.new("dsquery #{new_resource.type} -name #{new_resource.name}").run_command
        check.stdout.match("")
        # true if object doesn't exist
      end
	  
	  def add
	    if exists?
		  Chef::Log.error("The object already exists")
          new_resource.updated_by_last_action(false)
	    else
		  cmd = dsadd
		  cmd << "#{new_resource.type}"
		  
	    end
		
		new_resource.updated_by_last_action(true)
	  end
	  
	  def ldappath
	    if new_resource.type == "ou"
	      if new_resource.ou.nil?
	        ldappath << ""
	      else	  
	        ldappath << new_resource.ou.split("/").reverse.map! { |k| "ou=#{k}" }.join(",")
		    ldappath << ","
	      end
	    else 
	      ldappath << "cn=#{new_resource.ou},"
	    end
		
	    ldappath << new_resource.domain_name.split(".").map! { |k| "dc=#{k}" }.join(",")
	  end
	  
	  def options
	    case new_resource.type
        when "computer"
          if new_resource.samid.nil?
	      else
	        options << " -samid #{new_resource.samid}"
	      end
	      if new_resource.description.nil?
	      else
	        options << " -desc #{new_resource.description}"
	      end
	      if new_resource.memberof.nil?
	      else
	        options << " -memberof #{new_resource.memberof}"
	      end
	    when "contact"
	      options << " "
	      # Add parameters FirstName, Initial, LastName, DisplayName, Description, Office, PhoneNumber, Email, HomePhoneNumber, PagerNumber, CellPhoneNumber, FaxNumber, IPPhoneNumber, Title, Department, Company
	    when "group"
	      options << " "
	      # Add parameters secgrp, scope, Description, memberof, members
	    when "ou"
	      options << " "
	      # Add parameters Description
	    when "user"
	      options << " "
	      # Add parameters SAMName, UPN, FirstName, Initial, LastName, DisplayName, EmployeeID, Password, Description, memberof, Office, PhoneNumber, Email, HomePhoneNumber, PagerNumber, CellPhoneNumber, FaxNumber, IPPhoneNumber, WebPage, Title, Department, Company, ManagerDN, HomeDirectory, DriveLetter, ProfilePath, ScriptPath, mustchpwd, canchpwd
	  end
	  
      end
	end
  end
end
	