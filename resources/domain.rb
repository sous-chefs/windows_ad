actions :create, :delete, :join, :unjoin
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :domain_user, :kind_of => String
attribute :domain_pass, :kind_of => String
attribute :type, :kind_of => String, :default => "forest"
attribute :safe_mode_pass, :kind_of => String
attribute :options, :kind_of => Hash, :default => {}
attribute :local_pass, :kind_of => String