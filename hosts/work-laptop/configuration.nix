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

in
{
  imports = [
    #inputs.nixos-zaluru.nixosModules.configs
    ./hardware-configuration.nix
    ../../overlays/inputs
    ../../modules/nixos/import.nix
    ../../modules/shared/import.nix
    ../../modules/home/import.nix
  ];

  config = {

    system.stateVersion = "24.11";

    users.users.zaluru.initialPassword = "zaq1@WSX";

    # TODO: check if this even works (from what i remember reading - not really)
    nix.settings = {
      max-jobs = 2;
      cores = 2;
    };

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
        discord = enabled;
        signal-desktop = enabled;
        keepassxc = enabled;
        brave = enabled;
        thunderbird = enabled;
        alacritty = enabled;
        imv = enabled;
        firefox = enabled;
        gimp = enabled;
        obsidian = enabled;
        #steam = enabled;
        mpv = enabled;
        vscode = enabled;
        obs = enabled;
        remmina = enabled;
      };

      cli-tools = {
        ansible = enabled;
        charm-freeze = enabled;
        direnv = enabled;
        just = enabled;
        fastfetch = enabled;
        nixvim = enabled;
        zellij = enabled;
        tealdeer = enabled;
        croc = enabled;
        btop = enabled;
        lsof = enabled;
        yt-dlp = enabled;
        man-nvim = enabled;
        bat = enabled;
      };

      desktop = {
        kde = enabled;
        gdm = enabled;
        default-apps = enabled;
      };

      services = {
        ssh-agent = enabled;
 #       keyring-pam-kde = true;
        #mpd = enabled;
 #       docker = {
 #         enable = true;
 #         scripts.check-versions = false;
 #       };
      };

      system = {
        audio = {
          pipewire = enabled;
          #qpwgraph = enabled;
        };
        boot = {
          grub = enabled;
        };
        fonts = enabled;
        networking = {
          networkmanager = {
            enable = true;
            applet = false;
            hostname = "work-laptop";
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
        services = {
          fwupd = enabled;
        };
        utils = {
          dev = true;
          sysadmin = true;
        };
        defaultLocales = enabled;
      };
    };
  };
}

