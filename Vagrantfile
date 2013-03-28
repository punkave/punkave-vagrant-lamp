# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # The Box - - - - - - - - - - - -
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "dev"

  config.ssh.forward_agent = true

  # The Network - - - - - - - - - - - -
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3306, host: 33066
  
  config.vm.network :private_network, ip: "192.168.33.10"

  # The Folders - - - - - - - - - - - -
  config.vm.synced_folder ".", "/vagrant", :nfs => true
  config.vm.synced_folder "../../www", "/var/www", :nfs => true

  # The VM - - - - - - - - - - - -
  config.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id, 
      "--memory", "2048",
      "--cpus", "2"
    ]
  end
  
  # Provisioning - - - - - - - - - - - -
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'provision/manifests'
    puppet.module_path = 'provision/modules'
    puppet.options = ['--verbose']
  end
end
