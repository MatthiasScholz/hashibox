# -*- mode: ruby -*-
# vi: set ft=ruby :

# VirtualBox related configuration
# https://www.virtualbox.org/manual/ch08.html
vbox_config = [
  { '--memory' => '4096' },
  { '--cpus' => '2' },
  { '--cpuexecutioncap' => '100' },
  { '--biosapic' => 'x2apic' },
  { '--ioapic' => 'on' },
  { '--largepages' => 'on' },
  { '--natdnshostresolver1' => 'on' },
  { '--natdnsproxy1' => 'on' },
  { '--nictype1' => 'virtio' },
  { '--audio' => 'none' },
]

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # vagrant box list -i
  config.vm.box = "nixbox"

  # set hostname
  config.vm.hostname = "hashibox"

  # Nix way of adding package inline
  # config.vm.provision :nixos,
  #                     run: 'always',
  #                     verbose: true,
  #                     expression: {
  #                       environment: {
  #                         systemPackages: [ :envoy, :nomad, :consul, :docker ]
  #                       }
  #                     }
  # Nix way of adding packages using an additional file
  config.vm.provision :nixos,
                      run: 'always',
                      path: "configuration.nix",
                      verbose: true

  # Apply Virtualbox specific configuration
  config.vm.provider :virtualbox do |vb|
    vbox_config.each do |hash|
      hash.each do |key, value|
        vb.customize ['modifyvm', :id, "#{key}", "#{value}"]
      end
    end

    config.vm.network "private_network", ip: "192.168.56.193"
    config.vm.network "forwarded_port", guest: 22, host: 2256, id: 'ssh', auto_correct: true

    config.ssh.forward_agent = true
    config.ssh.insert_key = true
  end

  # FIXME NOT WORKING config.vm.network :private_network

  # TODO Port Forwarding
  # https://github.com/hashicorp/vagrant/issues/12045
  # https://docs.vmware.com/en/VMware-Fusion/12/rn/VMware-Fusion-12-Release-Notes.html
  # FIXME NOT WORKING
  # config.vm.provider :vmware_desktop do |v|
  #   v.ssh_info_public = true
  # end
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 4646, host: 14646 # nomad
  config.vm.network "forwarded_port", guest: 8500, host: 18500 # consul
  config.vm.network "forwarded_port", guest: 8600, host: 18600, protocol: 'udp' # consul dns

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # NOTE: Disabled because of an error during `vagrant up`
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
end
