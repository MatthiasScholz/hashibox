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

    # NOTE Not working config.vm.network "public_network", type: "dhcp"
    # NOTE Not working config.vm.network "public_network", ip: "192.168.178.190"

    # NOTE Only needed when virtual machines have to talk to each other
    # config.vm.network "private_network", ip: "192.168.56.190" # host 'vboxnet' subnet
    # NOTE: Not working: config.vm.network "private_network", type: "static", ip: "192.168.56.191", virtualbox__intnet: "hashiboxnet"
    # NOTE: Not working config.vm.network "private_network", type: "dhcp"

    # TODO Check if needed
    config.ssh.forward_agent = true

    config.ssh.insert_key = true
  end

  # TODO Port Forwarding
  # https://github.com/hashicorp/vagrant/issues/12045
  # https://docs.vmware.com/en/VMware-Fusion/12/rn/VMware-Fusion-12-Release-Notes.html
  # FIXME NOT WORKING
  config.vm.provider :vmware_desktop do |vmware|
    #vmware.ssh_info_public = true

    # NOTE: NOT WORKING config.vm.network "private_network", auto_config: false
    # config.vm.network "private_network", ip: "192.168.178.190"
    # config.vm.network "public_network", type: "dhcp"
    #config.vm.network "private_network", type: "dhcp"

    # TODO check usage
    #vmware.vmx["ethernet1.pcislotnumber"] = "33"
    #vmware.vmx["ethernet2.pcislotnumber"] = "34"

    # Make UI available
    vmware.gui = true

    vmware.vmx["memsize"] = "4096"
    vmware.vmx["numvcpus"] = "4"
  end
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", id: "nomad", guest: 4646, host: 4646, auto_correct: true # nomad
  config.vm.network "forwarded_port", id: "consul", guest: 8500, host: 8500, auto_correct: true # consul
  config.vm.network "forwarded_port", id: "consuldns", guest: 8600, host: 8600, protocol: 'udp', auto_correct: true # consul dns

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # NOTE: Disabled because of an error during `vagrant up`
  config.vm.synced_folder ".", "/vagrant", disabled: true

end
