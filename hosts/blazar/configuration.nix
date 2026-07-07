{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib.zaluru) enabled;
  inherit (config.mine) user;

  hostname = "blazar";

in
{
  imports = [
    ./hardware-configuration.nix
    ../../overlays/inputs
    (inputs.import-tree ../../modules)
    inputs.nix-private-config.nixosModules.configs
  ];

  config = {


  # Boot into a nixos iso and install with 
  # nix run github:nix-community/nixos-anywhere -- --flake '.#<hostname>' --target-host nixos@<ip>


    # yubikey
    services.pcscd.enable = true;

    
    environment.systemPackages = with pkgs; [
      devenv
    ];

    system.stateVersion = "25.11";

    mine = {

      trait = {
        cli = enabled;
        secrets.sops = enabled;
        base = enabled;
      };

      container = {
        quadlet-nix = {
          enable = true;
        };
      };

      #home-manager = {
      #};

      apps = {
      };

      cli-tools = {
        fastfetch = enabled;
        #nixvim = enabled;
        zellij = enabled;
        tealdeer = enabled;
        croc = enabled;
        bat = enabled;
      };

      desktop = {
      };

      services = {
        beszel.hub = enabled;
        woodpecker-server = enabled;
        kanidm.server = enabled;
        #proxmox-nixos = enabled;
        incus = enabled;
        forgejo = enabled;
        #ente = enabled;
      };

      system = {
        #boot = {
        #  grub = enabled;
        #};

        networking = {
          networkmanager = {
            enable = true;
            hostname = "${hostname}";
          };
        };
        security = {
          sudonopass = enabled;
        };
        services = {
          fwupd = enabled;
          #krb5 = enabled;
        };
        utils = {
          dev = true;
          sysadmin = true;
        };

        virtualisation = {
          libvirtd = enabled;
        };
        
      };
    };
  };
}
