actions :create, :modify, :move, :delete
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :domain_name, :kind_of => String
attribute :ou, :kind_of => String
attribute :options, :kind_of => Hash, :default => {}
