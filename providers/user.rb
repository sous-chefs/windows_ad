require 'mixlib/shellout'

action :create do
  if exists?
    Chef::Log.error("The object already exists")
    new_resource.updated_by_last_action(false)
  else
    cmd = "dsadd"
    cmd << " user "
    cmd << "\""
    cmd << dn
    cmd << "\""

    new_resource.options.each do |option, value|
     cmd << " -#{option} \"#{value}\""
     #  [-samid SAMName] [-upn UPN] [-fn FirstName] [-mi Initial] [-ln LastName] [-display DisplayName] [-empid EmployeeID] [-pwd {Password | *}] [-desc Description] [-memberof Group ...] [-office Office] [-tel PhoneNumber] [-email Email] [-hometel HomePhoneNumber] [-pager PagerNumber] [-mobile CellPhoneNumber] [-fax FaxNumber] [-iptel IPPhoneNumber] [-webpg WebPage] [-title Title] [-dept Department] [-company Company] [-mgr Manager] [-hmdir HomeDirectory] [-hmdrv DriveLetter:][-profile ProfilePath] [-loscr ScriptPath] [-mustchpwd {yes | no}] [-canchpwd {yes | no}] [-reversiblepwd {yes | no}] [-pwdneverexpires {yes | no}] [-acctexpires NumberOfDays] [-disabled {yes | no}] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}] [-q] [{-uc | -uco | -uci}]
    end

  execute "Create_#{new_resource.name}" do
    command cmd
  end

  new_resource.updated_by_last_action(true)
  end
end

action :modify do
  if exists?
    cmd = "dsmod"
    cmd << " user "
    cmd << dn

    new_resource.options.each do |option, value|
      cmd << " -#{option} #{value}"
      #  [-upn UPN] [-fn FirstName] [-mi Initial] [-ln LastName] [-display DisplayName] [-empid EmployeeID] [-pwd (Password | *)] [-desc Description] [-office Office] [-tel PhoneNumber] [-email E-mailAddress] [-hometel HomePhoneNumber] [-pager PagerNumber] [-mobile CellPhoneNumber] [-fax FaxNumber] [-iptel IPPhoneNumber] [-webpg WebPage] [-title Title] [-dept Department] [-company Company] [-mgr Manager] [-hmdir HomeDirectory] [-hmdrv DriveLetter:] [-profile ProfilePath] [-loscr ScriptPath] [-mustchpwd {yes | no}] [-canchpwd {yes | no}] [-reversiblepwd {yes | no}] [-pwdneverexpires {yes | no}] [-acctexpires NumberOfDays] [-disabled {yes | no}] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}][-c] [-q] [{-uc | -uco | -uci}] 
    end

    execute "Modify_#{new_resource.name}" do
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

    execute "Move_#{new_resource.name}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The object does not exist")
    new_resource.updated_by_last_action(false)
  end
end

action :delete do
  if exists?
    cmd = "dsrm "
    cmd << dn
    cmd << " -noprompt"

    new_resource.options.each do |option, value|
      cmd << " -#{option} #{value}"
      # [-subtree [-exclude]] [-noprompt] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}][-c][-q][{-uc | -uco | -uci}]
    end

    execute "Create_#{new_resource.name}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The object has already been removed")
    new_resource.updated_by_last_action(false)
  end
end

def dn
  if new_resource.reverse == "true"
    name = new_resource.name.split(" ").reverse.map! { |k| "#{k}" }.join("\\, ")
    dn = "cn=#{name},"
  else
    dn = "cn=#{new_resource.name},"
  end
  if /(U|u)sers/.match(new_resource.ou)
    dn << "cn=#{new_resource.ou},"
  else
    dn << new_resource.ou.split("/").reverse.map! { |k| "ou=#{k}" }.join(",")
    dn << ","
  end
  dn << new_resource.domain_name.split(".").map! { |k| "dc=#{k}" }.join(",")
end

def exists?
  if new_resource.reverse == "true"
    reverse_name = new_resource.name.split(" ").reverse.map! { |k| "#{k}" }.join(", ")
    contact = Mixlib::ShellOut.new("dsquery contact -name \"#{reverse_name}\"").run_command
    user = Mixlib::ShellOut.new("dsquery user -name \"#{reverse_name}\"").run_command
    contact.stdout.include? "DC" or user.stdout.include? "DC"
  else
    contact = Mixlib::ShellOut.new("dsquery contact -name #{new_resource.name}").run_command
    user = Mixlib::ShellOut.new("dsquery user -name #{new_resource.name}").run_command
    contact.stdout.include? "DC" or user.stdout.include? "DC"
  end
end
