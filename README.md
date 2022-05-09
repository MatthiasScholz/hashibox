# Hashibox

Vagrant setup for Hashicorp tooling and more, based on NixOS.

- nomad
- consul
- envoy
- temporal
- postgresql or mysql
- grafana
- prometheus
- alertmanager
- tempo
- loki
- OpenTelemetry

## Tasks

- [ ] Minimal working example
- [ ] NixOS Configuration in a separate file
- [ ] Hashicorp tooling and services

## Usage

```
make up
```

## Prerequisites

- vagrant

## References

- [Github: NixOS Vagrant Plugin](https://github.com/nix-community/vagrant-nixos-plugin)
- [Github: NixOS boxes for Vagrant](https://github.com/nix-community/nixbox)
- [Vagrant VMWare Box](https://www.vagrantup.com/docs/providers/vmware/boxes)
- [Vagrant Shared Folder](https://www.vagrantup.com/docs/synced-folders/basic_usage#disabling)
