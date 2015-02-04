#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Provider:: ou
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
  if parent?
  # indent all
    if exists?
      Chef::Log.debug("The object already exists")
      new_resource.updated_by_last_action(false)
    else
      cmd = "dsadd"
      cmd << " ou "
      cmd << "\""
      cmd << dn
      cmd << "\""

      cmd << cmd_options(new_resource.options)

      execute "Create_#{new_resource.name}" do
        command cmd
      end

      new_resource.updated_by_last_action(true)
    end
  else
    Chef::Log.error("The parent OU does not exist")
    new_resource.updated_by_last_action(false)
  end
end

action :modify do
  if exists?
    cmd = "dsmod"
    cmd << " ou "
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

    execute "Delete_#{new_resource.name}" do
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
  dn = "ou=#{new_resource.name},"
  unless new_resource.ou.nil?
    dn << new_resource.ou.split("/").reverse.map! { |k| "ou=#{k}" }.join(",") << ","
  end
  dn << new_resource.domain_name.split(".").map! { |k| "dc=#{k}" }.join(",")
end

def parent?
  if new_resource.ou.nil?
    true
  else
    ldap = new_resource.domain_name.split(".").map! { |k| "DC=#{k}" }.join(",")
    parent = Mixlib::ShellOut.new("dsquery ou -name \"#{new_resource.ou}\"").run_command
    path = "OU=#{new_resource.ou},"
    path << ldap
    parent.stdout.include? path
  end
end
def exists?
  if new_resource.ou.nil?
    ldap = new_resource.domain_name.split(".").map! { |k| "DC=#{k}" }.join(",")
  else
    ldap = "OU=#{new_resource.ou},"
    ldap << new_resource.domain_name.split(".").map! { |k| "DC=#{k}" }.join(",")
  end
  check = Mixlib::ShellOut.new("dsquery ou -name \"#{new_resource.name}\"").run_command
  path = "OU=#{new_resource.name},"
  path << ldap
  check.stdout.include? path
end
