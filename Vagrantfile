# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "vagrant-windows_ad"
  config.vm.box_url = "D:/VirtualBoxes/base-boxes/windows_2008_r2_virtualbox.box"
  config.vm.guest = :windows


  # Port forward WinRM and RDP (changed values to NOT conflict with host)
  config.vm.network :forwarded_port, guest: 3389, host: 3391
  config.vm.network :forwarded_port, guest: 5985, host: 5987, id: "winrm", auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
  #  vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.omnibus.chef_version = :latest
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "D:/cookbooks"
  #   chef.roles_path = "D:/my-recipes/roles"
    chef.data_bags_path = "D:/cookbooks/chef-repo/data_bags"
	chef.add_recipe "windows_ad::contoso"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "vagrant-windows_ad"
  config.vm.box_url = "D:/VirtualBoxes/base-boxes/windows_2012_r2_virtualbox.box"
  config.vm.guest = :windows


  # Port forward WinRM and RDP (changed values to NOT conflict with host)
  config.vm.network :forwarded_port, guest: 3389, host: 3392
  config.vm.network :forwarded_port, guest: 5985, host: 5988, id: "winrm", auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
  #  vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.omnibus.chef_version = :latest
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "D:/cookbooks"
  #   chef.roles_path = "D:/my-recipes/roles"
    chef.data_bags_path = "D:/cookbooks/chef-repo/data_bags"
	chef.add_recipe "windows_ad::contoso"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  end
end