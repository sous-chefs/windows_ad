#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Provider:: group
# 
# Copyright 2013, Texas A&M
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'mixlib/shellout'

action :create do
  if exists?
    Chef::Log.debug("The object already exists")
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
    Chef::Log.debug("The object has already been removed")
    new_resource.updated_by_last_action(false)  
  end
end

def dn
  dn = "CN=#{new_resource.name},"
  dn << new_resource.ou.split("/").reverse.map { |k| "OU=#{k}" }.join(",") << ","
  dn << new_resource.domain_name.split(".").map! { |k| "DC=#{k}" }.join(",")
end

def exists?
  check = Mixlib::ShellOut.new("dsquery group -name \"#{new_resource.name}\"").run_command
  check.stdout.include? "DC"
end
