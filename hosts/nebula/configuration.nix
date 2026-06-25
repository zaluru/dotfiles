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
    (inputs.import-tree ../../modules)
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
      #xdg.configFile."wireplumber" = {
      #  source = ./audio/wireplumber;
      #  recursive = true;
      #};
    };

    specialisation."kde".configuration = {
      environment.etc."specialisation".text = "kde"; # Required for 'nh' to detect which specialization is currently running https://github.com/nix-community/nh?tab=readme-ov-file#specialisations-support
      system.nixos.tags = [ "with-kde" ];
      home-manager.users.${user.name} = {
        specialisation."kde".configuration = {
          xdg.dataFile."home-manager/specialisation".text = "kde";
        };
      };

      mine = {
        apps = {
          steam = {
            enable = true;
            hide-games-desktop-entry = true;
          };
          heroic-games-launcher = enabled;
          hamachi = {
            enable = true;
            startOnBoot = false;
          };
          java-web-start = enabled;
          waydroid = enabled;
          bruno = enabled;
          keepassxc = enabled;
          brave = enabled;
          thunderbird = enabled;
          alacritty = enabled;
          imv = enabled;
          signal-desktop = enabled;
          #chromium = enabled;
          discord = enabled;
          #element = enabled;
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
          vlc = enabled;
          mpv = enabled;
          #vscodium = enabled;
          vscode = enabled;
          #zed = enabled;
          obs = enabled;
          blender = enabled;
          davinci-resolve = enabled;
          #affinity = enabled;
          renoise = {
            enable = true;
            full-version = {
              enable = true;
              version = "3.5.4";
            };
          };
          scarlett-gui = enabled;
          remmina = enabled;
          losless-cut = enabled;
          vicinae = enabled;
          nix-flatpak = {
            enable = true;

            ## Tools
            proton-plus = enabled;
            bottles = enabled;

            ## Creative
            trenchbroom = enabled;
            krita = enabled;
            upscayl = enabled;
            blockbench = enabled;
            digikam = enabled;
            material-maker = enabled;
            drawy = enabled;

            bitwarden = enabled;

            ## Games
            #pcsx2 = enabled;
            #rpcs3 = enabled;
            #shadps4 = enabled;
            #duckstation = enabled;
            prism-launcher = enabled;
            #ente-auth = enabled;
            #vintage-story = enabled;
            beyond-all-reason = enabled;
            retrodeck = enabled;
            taisei-project = enabled;
          };
        };

        desktop = {
          kde = {
            enable = true;
            panel.screen = 1;
            launcher = "vicinae";
          };
          plasma-login = enabled;
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

        system = {
          services = {
            keyring-pam-kde = enabled;
            #pam-u2f-totp = enabled;
          };
        };
      };
    };

    specialisation."steam-ui".configuration = {
      environment.etc."specialisation".text = "steam-ui"; # Required for 'nh' to detect which specialization is currently running https://github.com/nix-community/nh?tab=readme-ov-file#specialisations-support
      system.nixos.tags = [ "with-steam-ui" ];
      home-manager.users.${user.name} = {
        specialisation."steam-ui".configuration = {
          xdg.dataFile."home-manager/specialisation".text = "steam-ui";
        };
      };
      mine = {
        desktop = {
          steam-ui = enabled;
        };
        system = {
          virtual-display = {
            enable = true;
            output-id = "HDMI-A-2";
            resolution = "3840x2160";
            refresh-rate = 60;
          };
        };
      };
    };

    mine = {
      user = {
        enable = true;
        home-manager = enabled;
        shell.package = pkgs.fish;
        xdg-default-dirs = enabled;
      };

      home-manager = {
        git = enabled;
        zoxide = enabled;
        atuin = enabled;
        fzf = enabled;
        presenterm = enabled;
        ssh-config = enabled;
        #zsh = enabled;
      };

      apps = {
        mangohud = enabled;
        cables = enabled;
        syncthing = {
          enable = true;
          isNix = true;
        };
      };

      cli-tools = {
        ansible = enabled;
        charm-freeze = enabled;
        direnv = enabled;
        devbox = enabled;
        just = enabled;
        #ncmpcpp = enabled;
        fastfetch = enabled;
        #nixvim = enabled;
        zellij = enabled;
        tealdeer = enabled;
        croc = enabled;
        btop = enabled;
        lsof = enabled;
        yt-dlp = enabled;
        man-nvim = enabled;
        bat = enabled;
        age = enabled;
        sops-nix = {
          enable = true;
          ageKeyFile.path = "/home/zaluru/.config/sops/age/keys.txt";
          defaultSopsFile = inputs.nix-private-config.packages.${pkgs.stdenv.hostPlatform.system}.mySecrets + "/encrypted/nebula.yaml";
        };
        #vagrant = enabled;
      };



      services = {
        beszel.agent = enabled;
        kanidm-client = enabled;
        #nixarr = enabled;
        cockpit = enabled;
        #nextdns = enabled;
        lact = enabled;
        sunshine = enabled;
        mpd = enabled;
        kdeconnect = enabled;
        #};
        ssh-agent = enabled;
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
            hostname = "nebula";
          };
          firewall = enabled;
        };
        nix = {
          unfree = enabled;
          flakes = enabled;
          nh = enabled;
          index = enabled;
          github-access-token = enabled;
        };
        security.sudonopass = enabled;
        services = {
          gamemode = enabled;
          gamescope = enabled;
          #fix-8bitdo-ubc = enabled;
          fwupd = enabled;
          #  bluetooth = {
          #    enable = true;
          #    applet = true;
          #  };
          #  fix-suspend = enabled;
          #  input-remapper = enabled;
          #  keyring = enabled;
          openssh = enabled;
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

