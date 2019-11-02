#
# Author:: Miguel Ferreira (<miguelferreira@me.com>)
# Cookbook:: windows_ad
# Provider:: group_member
#
# Copyright:: 2015, Schuberg Philis B.V.

actions :add, :remove
default_action :add

attribute :user_name, kind_of: String, name_attribute: true
attribute :group_name, kind_of: String, required: true
attribute :domain_name, kind_of: String
attribute :user_ou, kind_of: String
attribute :group_ou, kind_of: String
attribute :cmd_user, kind_of: String
attribute :cmd_pass, kind_of: String
attribute :cmd_domain, kind_of: String
