# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.box_url = "https://github.com/CommanderK5/packer-centos-template/releases/download/0.6.8/vagrant-centos-6.8.box"
  config.vm.box = "centos-min"
  config.vm.provision "shell", inline: "yum -y update nss\*"

  # Fix for https://bugs.centos.org/view.php?id=9212
  config.vm.provision "shell", inline: "yum -y update python"

  config.vm.synced_folder "provisioning/salt/roots/", "/srv/"

  unless ENV['VAGRANT_SKIP_PYPI_DEV'] == '1'
    config.vm.define "pypi_dev" do |pypi_dev|

      pypi_dev.vm.hostname = "pypi-dev"
      pypi_dev.vm.network "private_network", ip: "192.168.57.9"
      pypi_dev.vm.network "private_network", ip: "172.16.57.9"

      pypi_dev.vm.provision :salt do |s|
        s.verbose = true
        s.minion_config = "provisioning/salt/minion/web/pypi_dev"
        s.run_highstate = true
      end
    end
  end

  if ENV['VAGRANT_BACKUP'] == '1'

    config.vm.define "backup" do |backup|
      backup.vm.network "private_network", ip: "192.168.57.201"
      backup.vm.network "private_network", ip: "172.16.57.201"

      backup.vm.provider :virtualbox do |vm|
        file_to_disk = '.vagrant/tmp/backup.vdi'
        vm.customize ['createhd', '--filename', file_to_disk, '--size', 10 * 1024]
        vm.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
      end

      backup.vm.provision :salt do |s|
        s.verbose = true
        s.install_type = "git v0.17.2"
        s.minion_config = "provisioning/salt/minion/backup/server"
        s.run_highstate = true
      end
    end

  end

  if ENV['VAGRANT_MONITORING'] == '1'
    config.vm.define "monitoring_server" do |monitoring_server|

      monitoring_server.vm.hostname = "pypi-monitoring"
      monitoring_server.vm.network "private_network", ip: "192.168.57.200"
      monitoring_server.vm.network "private_network", ip: "172.16.57.200"

      monitoring_server.vm.provision :salt do |s|
        s.verbose = true
        s.install_type = "git v0.17.2"
        s.minion_config = "provisioning/salt/minion/monitoring/server"
        s.run_highstate = true
      end
    end
  end

  if ENV['VAGRANT_PYPI'] == '1'
    config.vm.define "pypi" do |pypi|

      pypi.vm.network "private_network", ip: "192.168.57.10"
      pypi.vm.network "private_network", ip: "172.16.57.10"

      pypi.vm.provision :salt do |s|
        s.verbose = true
        s.install_type = "git v0.17.2"
        s.minion_config = "provisioning/salt/minion/web/pypi"
        s.run_highstate = true
      end
    end

    config.vm.define "pypi_log" do |pypi_log|

      pypi_log.vm.network "private_network", ip: "192.168.57.15"
      pypi_log.vm.network "private_network", ip: "172.16.57.15"

      pypi_log.vm.provision :salt do |s|
        s.verbose = true
        s.install_type = "git v0.17.2"
        s.minion_config = "provisioning/salt/minion/web/pypi_log"
        s.run_highstate = true
      end
    end

    config.vm.define "mirror" do |mirror|

      mirror.vm.network "private_network", ip: "192.168.57.20"

      mirror.vm.provision :salt do |s|
        s.verbose = true
        s.install_type = "git v0.17.2"
        s.minion_config = "provisioning/salt/minion/web/mirror"
        s.run_highstate = true
      end
    end
  end

end
