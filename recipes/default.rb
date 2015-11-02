#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Recipe:: default
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
if node['os_version'] >= '6.2'
  [
    'Microsoft-Windows-GroupPolicy-ServerAdmintools-Update',
    'ServerManager-Core-RSAT',
    'ServerManager-Core-RSAT-Role-Tools',
    'RSAT-AD-Tools-Feature',
    'RSAT-ADDS-Tools-Feature',
    'ActiveDirectory-Powershell',
    'DirectoryServices-DomainController-Tools',
    'DirectoryServices-AdministrativeCenter',
    'DirectoryServices-DomainController'
  ].each do |feature|
    windows_feature feature do
      action :install
    end
  end
else
  [
    'NetFx3',
    'Microsoft-Windows-GroupPolicy-ServerAdminTools-Update',
    'DirectoryServices-DomainController'
  ].each do |feature|
    windows_feature feature do
      action :install
    end
  end
  Chef::Log.error('This version of Windows Server is currently unsupported
                  beyond installing the required roles and features')
end
