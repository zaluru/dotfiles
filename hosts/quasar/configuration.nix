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

in
{
  imports = [
    #inputs.nixos-zaluru.nixosModules.configs
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
    ../../overlays/inputs
    ../../modules/nixos/import.nix
    ../../modules/shared/import.nix
    ../../modules/home/import.nix
  ];

  config = {

    system.stateVersion = "25.11";

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
      user = {
        enable = true;
        home-manager = enabled;
        #ghToken = enabled;
        shell.package = pkgs.fish;
        xdg-default-dirs = enabled;
      };

      home-manager = {
        git = enabled;
        ssh-config = enabled;
        #zsh = enabled;
      };

      apps = {
      };

      cli-tools = {
        direnv = enabled;
        just = enabled;
        #nixvim = enabled;
        zellij = enabled;
        #tealdeer = enabled;
        #croc = enabled;
        btop = enabled;
        lsof = enabled;
        #bat = enabled;
      };

      desktop = {
      };

      services = {
      };

      system = {
        #boot = {
        #  grub = enabled;
        #};
        networking = {
          networkmanager = {
            enable = true;
            hostname = "quasar";
          };
          firewall = enabled;
        };
        nix = {
          unfree = enabled;
          flakes = enabled;
          nh = enabled;
          index = enabled;
        };
        security.sudonopass = enabled;
        utils = {
          dev = true;
          sysadmin = true;
        };
        services = {
          openssh = enabled;
        }
        defaultLocales = enabled;
      };
    };
  };
}

