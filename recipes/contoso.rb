#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Recipe:: contoso
#
# Copyright 2013, Texas A&M
include_recipe 'windows_ad'

windows_ad_domain 'contoso.local' do
  action :create
  type 'forest'
  safe_mode_pass 'Passw0rd'
end
