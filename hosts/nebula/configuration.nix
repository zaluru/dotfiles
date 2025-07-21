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

    # TODO: check if this even works (from what i remember reading - not really)
    nix.settings = {
      max-jobs = 2;
      cores = 2;
    };

    home-manager.users.${user.name} = {
      # https://wiki.archlinux.org/title/WirePlumber
      # usefull commands
      # wpctl status
      # wpctl info <id> - here you can find the device.name or node.name and add rules by matching them
      # Making my audio interface ports input only
      xdg.configFile."wireplumber" = {
        source = ./audio/wireplumber;
        recursive = true;
      };
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
        bitwarden = enabled;
        keepassxc = enabled;
        brave = enabled;
        thunderbird = enabled;
        alacritty = enabled;
        imv = enabled;
        signal-desktop = enabled;
        #chromium = enabled;
        discord = enabled;
        element = enabled;
        firefox = enabled;
        #flycast = enabled;
        #freecad = enabled;
        #ghostty = enabled;
        gimp = enabled;
        #gthumb = enabled;
        inkscape = enabled;
        #keybase = enabled;
        #keymapp = enabled;
        obsidian = enabled;
        #proton = enabled;
        #prusa-slicer = enabled;
        #puddletag = enabled;
        steam = enabled;
        syncthing = {
          enable = true;
          isNix = true;
        };
        vlc = enabled;
        mpv = enabled;
        #vscodium = enabled;
        vscode = enabled;
        obs = enabled;
        blender = enabled;
        davinci-resolve = enabled;
        renoise = {
          enable = true;
          full-version = {
            enable = true;
            version = "3.4.4";
          };
        };
        scarlett-gui = enabled;
        remmina = enabled;
        nix-flatpak = {
          enable = true;
          trenchbroom = enabled;
          krita = enabled;
          pcsx2 = enabled;
          prism-launcher = enabled;
          rpcs3 = enabled;
          shadps4 = enabled;
          vintage-story = enabled;
          duckstation = enabled;
          beyond-all-reason = enabled;
        };
      };

      cli-tools = {
        ansible = enabled;
        charm-freeze = enabled;
        direnv = enabled;
        just = enabled;
        ncmpcpp = enabled;
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
        #sops = {
        #  enable = true;
        #  requires.unlock = true;
        #  defaultSopsFile = inputs.nixos-zaluru.packages.${pkgs.system}.mySecrets + "/encrypted/secrets.yaml";
        #};
        #vagrant = enabled;
      };

      container = {
        settings = {
          configPath = "${user.homeDir}/configs";
        };
        #traefik = {
        #  enable = true;
        #  awsEnvKeys = true;
        #  domainName = "zaluru.pw";
        #};
      };

      desktop = {
        kde = enabled;
        gdm = enabled;
        default-apps = enabled;
        #cursor = enabled;
        #fuzzel = enabled;
        #hypridle = enabled;
        #hyprland = {
        #  enable = true;
        #  home = true;
        #};
        #hyprlock = enabled;
        #hyprpaper = enabled;
        #screenshots = enabled;
        #swaync = enabled;
        #systemd = enabled;
        #waybar = enabled;
      };

      services = {
        cockpit = enabled;
        lact = enabled;
        sunshine = enabled;
        mpd = enabled;
        #beszel = {
        #  enable = true;
        #  isAgent = true;
        #};
        docker = {
          enable = true;
          scripts.check-versions = false;
        };
        #ollama = enabled;
        #prometheus = {
        #  enable = true;
        #  exporters = {
        #    node = enabled;
        #    smartctl = enabled;
        #    zfs = enabled;
        #  };
        #};
        #tailscale = {
        #  enable = true;
        #  authKeyFile = config.sops.secrets."tailscale/AUTH_KEY".path;
        #  useRoutingFeatures = "client";
        #};
      };

      system = {
        audio = {
          pipewire = enabled;
          musnix = enabled;
          qpwgraph = enabled;
        };
        boot = {
          grub = enabled;
        };
        fonts = enabled;
        networking = {
          networkmanager = {
            enable = true;
            applet = true;
            hostname = "nebula";
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
          gamemode = enabled;
          gamescope = enabled;
          fix-8bitdo-ubc = enabled;
          fwupd = enabled;
          #  bluetooth = {
          #    enable = true;
          #    applet = true;
          #  };
          #  fix-suspend = enabled;
          #  input-remapper = enabled;
          #  keyring = enabled;
          #  openssh = enabled;
          #  sleep-on-lan = enabled;
        };
        utils = {
          dev = true;
          sysadmin = true;
        };
        #video.amd = enabled;
        #virtualisation = {
        #  libvirtd = enabled;
        #};
        defaultLocales = enabled;
      };
    };
  };
}

