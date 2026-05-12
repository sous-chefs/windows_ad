# frozen_string_literal: true
#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook:: windows_ad
# Resource:: features
#
# Copyright:: 2013, Texas A&M

resource_name :windows_ad_features
provides :windows_ad_features
unified_mode true

default_action :install

property :features, Array, default: %w(
  Microsoft-Windows-GroupPolicy-ServerAdminTools-Update
  ServerManager-Core-RSAT
  ServerManager-Core-RSAT-Role-Tools
  RSAT-AD-Tools-Feature
  RSAT-ADDS-Tools-Feature
  ActiveDirectory-Powershell
  DirectoryServices-DomainController-Tools
  DirectoryServices-AdministrativeCenter
  DirectoryServices-DomainController
)
property :all, [true, false], default: true

action :install do
  new_resource.features.each do |feature|
    windows_feature feature do
      action :install
      all new_resource.all
    end
  end
end
