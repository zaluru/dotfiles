{
  lib,
  config,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
let

  inherit (lib.zaluru) enabled;
  inherit (config.mine) user;

  hostname = "quasar";

in
{
  imports = [
    #inputs.nixos-zaluru.nixosModules.configs
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ../../overlays/inputs
    (inputs.import-tree ../../modules)
    inputs.nix-private-config.nixosModules.configs
  ];

  config = {
    services.resolved.enable = true; # Required for netbird dns

    system.stateVersion = "26.05";

    boot.loader.grub = {
      enable = true;
      efiSupport = false;
      device = "/dev/sda";
    };

    # TODO: check if this even works (from what i remember reading - not really)
    nix.settings = {
      max-jobs = 2;
      cores = 2;
    };

    services.qemuGuest.enable = true;

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
        zellij = enabled;
        tealdeer = enabled;
        bat = enabled;
      };

      desktop = {
      };

      services = {
        #personal-website = enabled;
        #zitadel = enabled;
        #netbird = enabled;
        #pelican-wings = enabled;
        #pelican = enabled;
        #authentik = enabled;
        #romm = enabled;

        beszel.hub = enabled;
        woodpecker-server = enabled;
        kanidm.server = enabled;
        #proxmox-nixos = enabled;
        incus = enabled;
        forgejo = enabled;
        #ente = enabled;
        perses = enabled;
      };

      system = {
        networking = {
          networkmanager = {
            enable = true;
            hostname = "${hostname}";
          };
        };
        nix = {
          nh = enabled;
          index = enabled;
        };
        security.sudonopass = enabled;
        utils = {
          dev = true;
          sysadmin = true;
        };
      };

      defaults.web = {
        domainName = "";
        acmeEmail = "";
      };

    };
  };
}

