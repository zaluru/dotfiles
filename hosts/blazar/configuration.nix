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
      };

      user = {
        enable = true;
        home-manager = enabled;
        #ghToken = enabled;
        shell.package = pkgs.fish;
        xdg-default-dirs = enabled;
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
        beszel = {
          agent = enabled;
          hub = enabled;
        };
        woodpecker-server = enabled;
        kanidm = {
          client = enabled;
          server = enabled;
        };
        netbird.client.main = enabled;
        #proxmox-nixos = enabled;
        incus = enabled;
        forgejo = enabled;
        #ente = enabled;
        cockpit = enabled; 
      };

      system = {
        #boot = {
        #  grub = enabled;
        #};
        fonts = enabled;

        networking = {
          networkmanager = {
            enable = true;
            hostname = "${hostname}";
          };
          firewall = enabled;
        };
        nix = {
          unfree = enabled;
          flakes = enabled;
          nh = enabled;
          index = enabled;
        };
        security = {
          sudonopass = enabled;
        };
        services = {
          openssh = enabled;
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
        defaultLocales = enabled;
      };
    };
  };
}
