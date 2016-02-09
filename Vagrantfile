# -*- mode: ruby -*-
# vi: set ft=ruby :

win_2008_r2_box          = 'opentable/win-2008r2-standard-amd64-nocm'
win_20008_r2_box_url     = 'https://atlas.hashicorp.com/opentable/boxes/win-2008r2-standard-amd64-nocm'
# win_2008_r2_box        = 'opentable/win-2008r2-enterprise-amd64-nocm'
# win_20008_r2_box_url   = 'https://atlas.hashicorp.com/opentable/boxes/win-2008r2-enterprise-amd64-nocm'
win_2012_box             = 'kensykora/windows_2012_r2_standard'
win_2012_box_url         = 'https://atlas.hashicorp.com/kensykora/boxes/windows_2012_r2_standard'
win_2012_r2_box          = 'opentable/win-2012r2-standard-amd64-nocm'
win_2012_r2_box_url      = 'https://atlas.hashicorp.com/opentable/boxes/win-2012r2-standard-amd64-nocm'
win_2012_r2_core_box     = 'kensykora/windows_2012_r2_standard_core'
win_2012_r2_core_box_url = 'https://atlas.hashicorp.com/kensykora/boxes/windows_2012_r2_standard_core'
win_7_box                = 'opentable/win-7-enterprise-amd64-nocm'
win_7_box_url            = 'https://atlas.hashicorp.com/opentable/boxes/win-7-enterprise-amd64-nocm'
#win_7_box               = 'opentable/win-7-professional-amd64-nocm'
#win_7_box_url           = 'https://atlas.hashicorp.com/opentable/boxes/win-7-professional-amd64-nocm'
win_8_box                = 'opentable/win-8.1-enterprise-amd64-nocm'
win_8_box_url            = 'https://atlas.hashicorp.com/opentable/boxes/win-8.1-enterprise-amd64-nocm'

machines = {
  'win2012r2core' => {
    'hostname'   => 'win2012r2core',
    'box'        => win_2012_r2_core_box,
    'ip'         => '192.168.1.13',
  	'http_port'  => '8095',
  	'rdp_port'   => '8096',
  	'winrm_port' => '8097',
    'run_list'   => [
      'recipe[test_windows_ad::setup_dc]'
    ]
  },
  'win2008r2' => {
    'hostname'   => 'win2008r2',
    'box'        => win_2008_r2_box,
    'ip'         => '192.168.1.10',
  	'http_port'  => '8080',
  	'rdp_port'   => '8081',
  	'winrm_port' => '8082',
    'run_list'   => [
#      'recipe[test_windows_ad::setup_dc]'
      'recipe[test_windows_ad::join_domain]',
      'recipe[test_windows_ad::unjoin_domain]'
    ]
  },
  'win2012' => {
    'hostname'   => 'win2012',
    'box'        => win_2012_box,
    'ip'         => '192.168.1.11',
  	'http_port'  => '8085',
  	'rdp_port'   => '8086',
  	'winrm_port' => '8087',
    'run_list'   => [
#      'recipe[test_windows_ad::setup_dc]'
      'recipe[test_windows_ad::join_domain]',
      'recipe[test_windows_ad::unjoin_domain]'
    ]
  },
  'win2012r2' => {
    'hostname'   => 'win2012r2',
    'box'        => win_2012_r2_box,
    'ip'         => '192.168.1.12',
  	'http_port'  => '8090',
  	'rdp_port'   => '8091',
  	'winrm_port' => '8092',
    'run_list'   => [
#      'recipe[test_windows_ad::setup_dc]'
      'recipe[test_windows_ad::join_domain]',
      'recipe[test_windows_ad::unjoin_domain]'
    ]
  }   
}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |global_config|
  machines.each_pair do |name, options|
    global_config.vm.define name do |config|
      config.vm.box = name
      # Every Vagrant virtual environment requires a box to build off of.
      config.vm.box                        = options['box']
      config.vm.box_url                    = options['box_url']
	  config.vm.hostname                   = options['hostname']
	  
      config.vm.communicator = 'winrm'
      config.vm.guest = :windows

      port_80   = 1024 + rand(1024)
      # port_5985 = 1024 + rand(1024)
      # while port_5985 == port_80 do
      #   port_5985 = 1024 + rand(1024)
      # end
	  
	  config.vm.network :forwarded_port, guest: 80, host: options['http_port'], id: "http", auto_correct: true
      config.vm.network :forwarded_port, guest: 3389, host: options['rdp_port'], id: "rdp", auto_correct: true
	  config.vm.network :forwarded_port, guest: 5985, host: options['winrm_port'], id: "winrm", auto_correct: true
	  
      config.vm.network 'private_network', ip: options['ip'], virtualbox__intnet: 'windows_ad'
      config.vm.provider 'virtualbox' do |vb|
      #  vb.gui = true
        vb.customize ['modifyvm', :id, "--nicpromisc1", "allow-all" ]
        vb.customize ['modifyvm', :id, "--nicpromisc2", "allow-all" ]
	  #  vb.customize ['modifyvm', :id, "--natdnshostresolver1", "on" ]
	  #  vb.customize ['modifyvm', :id, "--natdnsproxy1", "on" ]
	  end

      config.omnibus.chef_version = :latest
#	  config.omnibus.chef_version = '11.18.12'
#      config.chef_zero.cookbooks    = [ 'test/fixtures/cookbooks', 'test/fixtures/test_cookbooks' ]

#       config.vm.provision 'chef_client', run: 'always' do |chef|
	  config.vm.provision 'chef_solo', run: 'always' do |chef|
        chef.log_level  = 'debug'
        chef.cookbooks_path = "../../cookbooks" 
#        chef.custom_config_path = 'Vagrantfile.chef'
        chef.file_cache_path    = 'c:/var/chef/cache'

        chef.run_list = options['run_list']

        # You may also specify custom JSON attributes:
        chef.json = { }
      end
    end
  end
end
