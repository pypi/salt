# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
  config.vm.box = "centos-min"

  config.vm.synced_folder "provisioning/salt/roots/", "/srv/"

  config.vm.define "pypi" do |pypi|
    pypi.vm.network "forwarded_port", guest: 80, host: 8080
    pypi.vm.network "forwarded_port", guest: 443, host: 8443
    pypi.vm.network "forwarded_port", guest: 8000, host: 8081

    pypi.vm.provision :salt do |s|
      s.verbose = true
      s.minion_config = "provisioning/salt/minion/pypi-minion"
      s.run_highstate = true
    end
  end

  config.vm.define "mirror" do |mirror|
    mirror.vm.network "forwarded_port", guest: 80, host: 8081
    mirror.vm.network "forwarded_port", guest: 443, host: 8444

    mirror.vm.provision :salt do |s|
      s.verbose = true
      s.minion_config = "provisioning/salt/minion/mirror-minion"
      s.run_highstate = true
    end
  end
end
