# -*- mode: ruby -*-
# vi: set ft=ruby :

standard_box = ENV['VAGRANT_TEST_BOX']

test_machines = {
  'test-dc' => {
    'box'      => standard_box,
    'ip'       => '192.168.56.5',
    'run_list' => [ 'recipe[test_windows_ad::setup_dc]' ]
  },
  'test-dm' => {
    'box'      => standard_box,
    'ip'       => '192.168.56.7',
    'run_list' => [ 'recipe[test_windows_ad::join_domain]' ]
  }
}

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |global_config|
  test_machines.each_pair do |name, options|
    global_config.vm.define name do |config|

      config.vm.hostname = name
      config.vm.box      = options['box']

      config.vm.communicator = 'winrm'
      config.vm.guest        = :windows

      config.vm.network 'private_network', ip: options['ip'], virtualbox__intnet: 'windows_ad'

      config.vm.provider 'virtualbox' do |vb|
        vb.gui = false
        vb.customize ['modifyvm', :id, "--nicpromisc1", "allow-all" ]
        vb.customize ['modifyvm', :id, "--nicpromisc2", "allow-all" ]
      end

      config.berkshelf.enabled = true

      config.omnibus.chef_version = 'latest'

      config.vm.provision 'chef_client', run: 'always' do |chef|
        chef.log_level = 'info'

        chef.custom_config_path = 'Vagrantfile.chef'
        chef.file_cache_path    = 'c:/var/chef/cache'

        chef.run_list = options['run_list']

        # You may also specify custom JSON attributes:
        chef.json = {
          'windows_ad' => { 'dc_ip' => '192.168.56.5' }
        }
      end
    end
  end
end
