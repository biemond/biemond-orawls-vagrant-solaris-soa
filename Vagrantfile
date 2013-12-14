# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "adminsol" , primary: true do |adminsol|
    adminsol.vm.box = "solaris10-x86_64"
    #adminsol.vm.box_url = "https://dl.dropboxusercontent.com/s/an5bthwroh1i8k5/solaris10-x86_64.box"
    adminsol.vm.box_url = "/Users/edwin/Downloads/solaris10-x86_64.box"

    adminsol.vm.hostname = "adminsol.example.com"
    adminsol.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    adminsol.vm.network :private_network, ip: "10.10.10.10"
  
  
    adminsol.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2548"]
      vb.customize ["modifyvm", :id, "--name", "adminsol"]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      #vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 0, '--device', 1, '--type', 'dvddrive', '--medium',  "/Users/edwin/Downloads/V36435-01.iso"]
    end
  
    adminsol.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    adminsol.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "site.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
        "env_app1"    => "application_One",
        "env_app2"    => "application_Two",
   }
      
    end
  
  end

  config.vm.define "dbsol" , primary: true do |dbsol|
    dbsol.vm.box = "solaris10-x86_64"
    dbsol.vm.box_url = "https://dl.dropboxusercontent.com/s/an5bthwroh1i8k5/solaris10-x86_64.box"
    #dbsol.vm.box_url = "/Users/edwin/Downloads/solaris10-x86_64.box"

    dbsol.vm.hostname = "dbsol.example.com"
    dbsol.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    dbsol.vm.network :private_network, ip: "10.10.10.5"
  
    dbsol.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm"     , :id, "--memory", "4096"]
      vb.customize ["modifyvm"     , :id, "--name", "dbsol"]
      vb.customize ["modifyvm"     , :id, "--cpus", 1]
      #vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 0, '--device', 1, '--type', 'dvddrive', '--medium',  "/Users/edwin/Downloads/V36435-01.iso"]
    end

  
    dbsol.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    dbsol.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "db.pp"
      puppet.options           = "--verbose --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
        "env_app1"    => "application_One",
        "env_app2"    => "application_Two",
      }
      
    end
  
  end

  
  config.vm.define "nodesol1" do |node1|

    node1.vm.box = "solaris10-x86_64"
    node1.vm.box_url = "https://dl.dropboxusercontent.com/s/an5bthwroh1i8k5/solaris10-x86_64.box"
  
    node1.vm.hostname = "nodesol1.example.com"
    node1.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    node1.vm.network :private_network, ip: "10.10.10.100"
  
    node1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2548"]
      vb.customize ["modifyvm", :id, "--name", "nodesol1"]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      #vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 0, '--device', 1, '--type', 'dvddrive', '--medium',  "/Users/edwin/Downloads/V36435-01.iso"]
    end
  
    node1.vm.provision :shell, :inline => "echo '10.10.10.100 nodesol1.example.com nodesol1' >> /etc/hosts ; ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    node1.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "node.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
        "env_app1"    => "application_One",
        "env_app2"    => "application_Two",
      }
      
    end

  end

  config.vm.define "nodesol2" do |node2|

    node2.vm.box = "solaris10-x86_64"
    node2.vm.box_url = "https://dl.dropboxusercontent.com/s/an5bthwroh1i8k5/solaris10-x86_64.box"

    node2.vm.hostname = "nodesol2.example.com"
    node2.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    node2.vm.network :private_network, ip: "10.10.10.200", auto_correct: true
  
    node2.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2548"]
      vb.customize ["modifyvm", :id, "--name", "nodesol2"]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      #vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 0, '--device', 1, '--type', 'dvddrive', '--medium',  "/Users/edwin/Downloads/V36435-01.iso"]
    end
  
    node2.vm.provision :shell, :inline => "echo '10.10.10.200 nodesol2.example.com nodesol2' >> /etc/hosts ; ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    node2.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "node.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
        "env_app1"    => "application_One",
        "env_app2"    => "application_Two",
      }
      
    end

  end

  config.vm.define "rcunod" do |rcunod|

    rcunod.vm.box = "centos-6.4-x86_64"
    rcunod.vm.box_url = "https://dl.dropboxusercontent.com/s/yg9ceak6zd86wk7/centos-6.4-x86_64.box"
  
    rcunod.vm.hostname = "rcunod.example.com"
  
    rcunod.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
  
    rcunod.vm.network :private_network, ip: "10.10.10.15"
  
    rcunod.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--name", "rcunod"]
    end
  
    rcunod.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    rcunod.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "rcu.pp"
      puppet.options           = "--verbose --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment"                     => "development",
        "vm_type"                         => "vagrant",
        "env_app1"                        => "application_One",
        "env_app2"                        => "application_Two",
      }
    end
  end

end
