#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Resource:: domain
#
# Copyright 2013, Texas A&M

actions :create, :delete
default_action :create

attribute :name, kind_of: String, name_attribute: true
attribute :domain_user, kind_of: String, required: true
attribute :domain_pass, kind_of: String, required: true
attribute :restart, kind_of: [TrueClass, FalseClass], required: true,
                    default: true
attribute :type, kind_of: String, default: 'forest'
attribute :safe_mode_pass, kind_of: String, required: true
attribute :options, kind_of: Hash, default: {}
attribute :local_pass, kind_of: String
attribute :replica_type, kind_of: String, default: 'domain'
attribute :ou, kind_of: String
