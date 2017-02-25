#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Recipe:: default
#
# Copyright 2013, Texas A&M

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
  Chef::Log.warn('This version of Windows Server may be missing some providei
                  support. Help us out by submitting a pull request.')
end
