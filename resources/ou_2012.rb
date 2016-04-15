#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Resource:: ou_2012
#
# Copyright 2016, Texas A&M

actions :create
default_action :create

attribute :name, kind_of: String, name_attribute: true
attribute :path, kind_of: String
attribute :domain_name, kind_of: String
attribute :options, kind_of: Hash, default: {}
attribute :cmd_user, kind_of: String
attribute :cmd_pass, kind_of: String
attribute :cmd_domain, kind_of: String
