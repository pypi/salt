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


  unless ENV['VAGRANT_SKIP_PYPI'] == '1'
    config.vm.define "pypi" do |pypi|

      pypi.vm.network "private_network", ip: "192.168.57.11"

      pypi.vm.provision :salt do |s|
        s.verbose = true
        s.minion_config = "provisioning/salt/minion/web/pypi"
        s.run_highstate = true
      end
    end

    config.vm.define "mirror" do |mirror|

      mirror.vm.network "private_network", ip: "192.168.57.20"

      mirror.vm.provision :salt do |s|
        s.verbose = true
        s.minion_config = "provisioning/salt/minion/web/mirror"
        s.run_highstate = true
      end
    end
  end

  if ENV['VAGRANT_POSTGRES_CLUSTER'] == '1'

    config.vm.define "pg_primary" do |pg_primary|
      pg_primary.vm.network "private_network", ip: "192.168.57.5"
      pg_primary.vm.network "private_network", ip: "172.16.57.5"

      pg_primary.vm.provision :salt do |s|
        s.verbose = true
        s.minion_config = "provisioning/salt/minion/pg_cluster/primary"
        s.run_highstate = true
      end
    end

    config.vm.define "pg_standby_0" do |pg_standby_0|
      pg_standby_0.vm.network "private_network", ip: "192.168.57.6"
      pg_standby_0.vm.network "private_network", ip: "172.16.57.6"

      pg_standby_0.vm.provision :salt do |s|
        s.verbose = true
        s.minion_config = "provisioning/salt/minion/pg_cluster/standby_0"
        s.run_highstate = true
      end
    end

    config.vm.define "pgpool_0" do |pgpool_0|
      pgpool_0.vm.network "private_network", ip: "192.168.57.7"
      pgpool_0.vm.network "private_network", ip: "172.16.57.7"

      pgpool_0.vm.provision :salt do |s|
        s.verbose = true
        s.minion_config = "provisioning/salt/minion/pg_cluster/pgpool_0"
        s.run_highstate = true
      end
    end

    config.vm.define "pgpool_1" do |pgpool_1|
      pgpool_1.vm.network "private_network", ip: "192.168.57.8"
      pgpool_1.vm.network "private_network", ip: "172.16.57.8"

      pgpool_1.vm.provision :salt do |s|
        s.verbose = true
        s.minion_config = "provisioning/salt/minion/pg_cluster/pgpool_1"
        s.run_highstate = true
      end
    end

  end

end
