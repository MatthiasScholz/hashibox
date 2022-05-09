{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    envoy
    nomad
    nomad-autoscaler
    cni-plugins
    levant
    consul
    docker
  ];

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/nomad.nix
  # TODO Configure /etc/nomad.json
  services.nomad = {
    enable = true;
    enableDocker = true;
    settings = {
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };

      client = {
        enabled = true;
        options = {
          "docker.volumes.enabled" = true;
        };
      };

      plugin = {
        "raw_exec" = {
          config = {
            enabled = true;
          };
        };
      };
    };
  };

  services.consul = {
    enable = true;
  };
}
