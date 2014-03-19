# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "windows-2012-standard"
  config.vm.guest = :windows
  config.vm.network :forwarded_port, guest: 3389, host: 3390
  config.vm.network :forwarded_port, guest: 5985, host: 5985
  #config.vm.provider "virtualbox" do |v|
  #  v.gui = true
  #end
  config.windows.halt_timeout = 15
  config.winrm.username = "administrator"
  config.winrm.password = "vagrant"
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe("windows")
    chef.add_recipe("windows_ad")
  end
  
end
