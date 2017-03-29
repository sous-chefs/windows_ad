#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Recipe:: contoso
#
# Copyright 2013, Texas A&M
#include_recipe 'windows_ad'
include_recipe 'test::join_domain'

#windows_ad_domain 'contoso.local' do
#  action :create
#  type 'replica'
#  safe_mode_pass 'Passw0rd'
#  domain_user 'Administrator'
#  domain_pass 'Passw0rd'
#end
