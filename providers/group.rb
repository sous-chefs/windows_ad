require 'mixlib/shellout'

action :create do
  if exists?
    Chef::Log.error("The object already exists")
    new_resource.updated_by_last_action(false)
  else
    cmd = "dsadd"
    cmd << " group "
    cmd << "\""
    cmd << dn
    cmd << "\""

    new_resource.options.each do |option, value|
     cmd << " -#{option} #{value}"
     # [-secgrp {yes | no}] [-scope {l | g | u}] [-samid SAMName] [-desc Description] [-memberof Group ...] [-members Member ...] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}] [-q] [{-uc | -uco | -uci}]
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
    cmd << " group "
    cmd << dn

    new_resource.options.each do |option, value|
      cmd << " -#{option} #{value}"
      # [-samid SAMName] [-desc Description] [-secgrp {yes | no}] [-scope {l | g | u}] [{-addmbr | -rmmbr | -chmbr} MemberDN ...] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}] [-c] [-q] [{-uc | -uco | -uci}] 
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

    execute "Delete_#{new_resource.name}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.error("The object has already been removed")
    new_resource.updated_by_last_action(false)  
  end
end

def dn
  dn = "CN=#{new_resource.name},"
  dn << "OU=#{new_resource.ou},"
  dn << new_resource.domain_name.split(".").map! { |k| "DC=#{k}" }.join(",")
end

def exists?
  check = Mixlib::ShellOut.new("dsquery group -name \"#{new_resource.name}\"").run_command
  check.stdout.include? "DC"
end
