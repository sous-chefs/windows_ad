#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Provider:: user
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
    cmd << " user "
    cmd << "\""
    cmd << dn
    cmd << "\""

    cmd << cmd_options(new_resource.options)

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

    cmd << cmd_options(new_resource.options)

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

    cmd << cmd_options(new_resource.options)

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

    cmd << cmd_options(new_resource.options)

    execute "Create_#{new_resource.name}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("The object has already been removed")
    new_resource.updated_by_last_action(false)
  end
end

def cmd_options(options)
  cmd = ''
  options.each do |option, value|
    cmd << " -#{option} \"#{value}\""
    # [-subtree [-exclude]] [-noprompt] [{-s Server | -d Domain}] [-u UserName] [-p {Password | *}][-c][-q][{-uc | -uco | -uci}]
  end
  cmd
end

def dn
  if new_resource.reverse == "true"
    name = new_resource.name.split(" ").reverse.map! { |k| k }.join("\\, ")
    dn = "CN=#{name},"
  else
    dn = "CN=#{new_resource.name},"
  end
  if new_resource.ou.downcase == 'users'
    dn << "CN=#{new_resource.ou},"
  else
    dn << new_resource.ou.split("/").reverse.map! { |k| "OU=#{k}" }.join(",")
    dn << ","
  end
  dn << new_resource.domain_name.split(".").map! { |k| "DC=#{k}" }.join(",")
end

def exists?
  if new_resource.reverse == "true"
    reverse_name = new_resource.name.split(" ").reverse.map! { |k| k }.join(", ")
    contact = Mixlib::ShellOut.new("dsquery contact -name \"#{reverse_name}\"").run_command
    user = Mixlib::ShellOut.new("dsquery user -name \"#{reverse_name}\"").run_command
    contact.stdout.include? "DC" or user.stdout.include? "DC"
  else
    contact = Mixlib::ShellOut.new("dsquery contact -name \"#{new_resource.name}\"").run_command
    user = Mixlib::ShellOut.new("dsquery user -name \"#{new_resource.name}\"").run_command
    contact.stdout.include? "DC" or user.stdout.include? "DC"
  end
end
