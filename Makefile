provider ?= vmware_desktop
vagrant_provider_name ?= vmware-iso
vagrant_box_name ?= nixbox
vagrant_box_file ?= nix-vmware.box

nixos_version := nixos/nixos-21.05-x86_64

all: setup init up

setup:
	vagrant plugin install vagrant-nixos-plugin
	vagrant plugin list

setup-provider-vmware:
	brew install --cask vagrant-vmware-utility
	brew services vagrant-vmware-utility vagrant-vmware-utility
	vagrant plugin install vagrant-vmware-desktop
	vagrant plugin list

setup-provider-virtualbox:
	brew install --cask virtualbox
	brew install --cask virtualbox-extension-pack

init:
	vagrant init $(nixos_version)

up:
	vagrant provision
	vagrant up --provider=$(provider)

status:
	vagrant status
	vagrant port

update:
	vagrant provision
	vagrant reload

ssh:
	vagrant ssh

ui:
	open http://localhost:8500
	open http://localhost:4646

base_vm_root_folder := ./nixbox
base-genkey:
	ssh-keygen -f $(base_vm_root_folder)/scripts/install_rsa -t ecdsa -b 521

vagrant_box := nix-vmware.box
base-build:
	cd $(base_vm_root_folder) && packer build --only=$(vagrant_provider_name) nixos-x86_64.json

output_folder := ./$(base_vm_root_folder)/output-$(vagrant_provider_name)
base-optimize-vmware:
	vmware-vdiskmanager -d $(output_folder)/disk.vmdk
	vmware-vdiskmanager -k $(output_folder)/disk.vmdk

base-package-prepare:
	rm -f $(vagrant_box_file)
	cp -f ./$(base_vm_root_folder)/metadata.json $(output_folder)/
	tar cvzf $(vagrant_box_file) --directory=$(output_folder)/ .

base-package:
	vagrant box add --name $(vagrant_box_name) $(vagrant_box_file)
	vagrant box list -i

base-package-virtualbox:
	vagrant box add --name $(vagrant_box_name) $(base_vm_root_folde)/nixos-21.11-virtualbox-x86_64.box
	vagrant box list -i
