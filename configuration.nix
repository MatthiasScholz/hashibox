{ config, pkgs, ... }:

{
  # VM-Ware Specifics
  virtualisation.vmware.guest.enable = true;
  # Interface is this on Intel Fusion
  # networking.interfaces.ens33.useDHCP = true;
  # Shared folder to host works on Intel
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };


  # To support 1Password
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # cluster ecosystem
    envoy
    nomad
    nomad-autoscaler
    cni-plugins
    levant
    consul
    docker
    # helper
    chromium
    # dev environment
    gnumake
    emacs
    ripgrep
    fd
  ];

  # FIXME NOT WORIKNG 'builtins' does not exists
  # builtins.fetchGit = {
  #       url = "https://github.com/MatthiasScholzTW/doom-emacs-config.git";
  #       rev = "5658a4c650955b3a00db3f707055b979df8eb5df";
  #       name = ".doom.d";
  # };

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/nomad.nix
  # TODO Configure /etc/nomad.json
  services.nomad = {
    enable = true;
    enableDocker = true;
    settings = {

      datacenter = "hashibox";

      bind_addr = "0.0.0.0";

      advertise = {
        http = "{{ GetPrivateIP }}";
        rpc = "{{ GetPrivateIP }}";
        serf = "{{ GetPrivateIP }}:5648";
      };

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

      consul = {
        address = "{{ GetPrivateIP }}:8500";
      };
    };
  };

  services.consul = {
    enable = true;
  };

  # Virtualization settings
  virtualisation.docker.enable = true;

  # Disable the firewall since we're in a VM and we want to make it
  # easy to visit stuff in here. We only use NAT networking anyways.
  networking.firewall.enable = false;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "no";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;


  # Neo

  #console.keyMap = "neo"

  # Graphical Support

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "neo";
    defaultLocale = "en_US.UTF-8";
  };

  # We expect to run the VM on hidpi machines.
  #hardware.video.hidpi.enable = true;

  # setup windowing environment
  services.xserver = {
    enable = true;
    #layout = "us";
    layout = "de";
    xkbVariant = "neo";
    # xkbOptions = "eurosign:e";
    # dpi = 220;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
      xfce.enable = true;
    };

    # displayManager = {
    #   defaultSession = "none+i3";
    #   lightdm.enable = true;
    # };

    displayManager.defaultSession = "xfce";

    # windowManager = {
    #   i3.enable = true;
    #   #notion.enable = true;
    # };
  };

  # NOTE: WORKING
  # services.xserver = {
  # # Enable the X11 windowing system.
  #   enable = true;
  #   layout = "de";
  #   xkbVariant = "neo";
  # # services.xserver.xkbOptions = "eurosign:e";
  # 
  #   windowManager = {
  #     xmonad = {
  #       enable = true;
  #       enableContribAndExtras = true;
  #     };
  #   };
  # 
  #   displayManager.defaultSession = "none+xmonad";
  # 
  #   synaptics = {
  #     enable = true;
  #     accelFactor = "0.01";
  #     maxSpeed = "3.0";
  #   };
  # };
}
