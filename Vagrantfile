# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

#  config.vm.hostname = "p2p-network-berkshelf"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise-server-cloudimg-vagrant-amd64-disk1"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-amd64-disk1.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
#  config.vm.network :private_network, ip: "33.33.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.

  # config.vm.network :public_network

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.omnibus.chef_version = :latest

  config.vm.define :host0 do |host0|
    host0.vm.hostname = "p2p-network-berkshelf-host0"
    host0.vm.network :private_network, ip: "33.33.33.10"
    host0.vm.provision :chef_solo do |chef|
    chef.json = {
      'p2p-network' => {
        'internal' => { 'ipaddress' => '10.123.123.10' },
        'external' => { "interface" => "eth1", 'ipaddress' => nil },
        'servers' => [
          { 'hostname' => "host1", "p2p-network" => { 'external' => { 'ipaddress' => "33.33.33.11" }, 'internal' => { 'ipaddress' => "10.123.123.11", "network" => "192.168.11.0/24" } } },
          { 'hostname' => "host2", "p2p-network" => { 'external' => { 'ipaddress' => "33.33.33.12" }, 'internal' => { 'ipaddress' => "10.123.123.12", "network" => "192.168.12.0/24" } } }
        ]
      }
    }

    chef.run_list = [
        "recipe[p2p-network::default]"
    ]
    end
  end

  config.vm.define :host1 do |host1|
    host1.vm.hostname = "p2p-network-berkshelf-host1"
    host1.vm.network :private_network, ip: "33.33.33.11"
    host1.vm.provision :chef_solo do |chef|
    chef.json = {
      'p2p-network' => {
        'internal' => { 'ipaddress' => '10.123.123.11' },
        'external' => { "interface" => "eth1", 'ipaddress' => nil },
        'servers' => [
          { 'hostname' => "host0", "p2p-network" => { 'external' => { 'ipaddress' => "33.33.33.10" }, 'internal' => { 'ipaddress' => "10.123.123.10", "network" => "192.168.10.0/24" } } },
          { 'hostname' => "host2", "p2p-network" => { 'external' => { 'ipaddress' => "33.33.33.12" }, 'internal' => { 'ipaddress' => "10.123.123.12", "network" => "192.168.12.0/24" } } }
        ]
      }
    }

    chef.run_list = [
        "recipe[p2p-network::default]"
    ]
    end
  end

  config.vm.define :host2 do |host2|
    host2.vm.hostname = "p2p-network-berkshelf-host2"
    host2.vm.network :private_network, ip: "33.33.33.12"
    host2.vm.provision :chef_solo do |chef|
    chef.json = {
      'p2p-network' => {
        'internal' => { 'ipaddress' => '10.123.123.12' },
        'external' => { "interface" => "eth1", 'ipaddress' => nil },
        'servers' => [
          { 'hostname' => "host0", "p2p-network" => { 'external' => { 'ipaddress' => "33.33.33.10" }, 'internal' => { 'ipaddress' => "10.123.123.10", "network" => "192.168.10.0/24" } } },
          { 'hostname' => "host1", "p2p-network" => { 'external' => { 'ipaddress' => "33.33.33.11" }, 'internal' => { 'ipaddress' => "10.123.123.11", "network" => "192.168.11.0/24" } } }
        ]
      }
    }

    chef.run_list = [
        "recipe[p2p-network::default]"
    ]
    end
  end

end
