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
    ./steam-config.nix
    ../../overlays/inputs
    (inputs.import-tree ../../modules)
    inputs.nix-private-config.nixosModules.configs
  ];

  config = {


    system.stateVersion = "24.11";

    # TODO: check if this even works (from what i remember reading - not really)
    nix.settings = {
      max-jobs = 2;
      cores = 2;
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

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
        trait = {
          desktop = {
            kde = enabled;
            base = enabled;
            base-flatpak = enabled;
            gaming = enabled;
          };
        };

        apps = {
          hamachi = {
            enable = true;
            startOnBoot = false;
          };
          waydroid = enabled;
          bruno = enabled;
          #puddletag = enabled;
          vlc = enabled;
          #zed = enabled;
          obs = enabled;
          blender = enabled;
          davinci-resolve = enabled;
          renoise = {
            enable = true;
            full-version = {
              enable = true;
              version = "3.5.4";
            };
          };
          scarlett-gui = enabled;
          losless-cut = enabled;
          nix-flatpak = {
            ## Tools
            proton-plus = enabled;

            ## Creative
            trenchbroom = enabled;
            krita = enabled;
            upscayl = enabled;
            blockbench = enabled;
            material-maker = enabled;
            drawy = enabled;


            ## Games
            prism-launcher = enabled;
            beyond-all-reason = enabled;
            retrodeck = enabled;
            taisei-project = enabled;
          };
        };

        desktop = {
          kde = {
            panel.screen = 1;
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

        trait = {
          desktop.base = enabled;
        };

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
      trait = {
        cli = enabled;
        secrets.sops = enabled;
        base = enabled;
      };

      user = {
        #guest = enabled;
      };

      home-manager = {
        presenterm = enabled;
      };

      apps = {
        cables = enabled;
        syncthing = {
          enable = true;
          isNix = true;
        };
      };

      cli-tools = {
        ansible = enabled;
        charm-freeze = enabled;
        devbox = enabled;
        #ncmpcpp = enabled;
        fastfetch = enabled;
        #nixvim = enabled;
        zellij = enabled;
        tealdeer = enabled;
        croc = enabled;
        man-nvim = enabled;
        bat = enabled;
      };


      container = {
        quadlet-nix = {
          enable = false;
        };
      };

      services = {
        #nixarr = enabled;
        #nixflix = enabled; 
        #nextdns = enabled;
        lact = enabled;
        #sunshine = enabled;
        yubikey-agent = enabled;
        gpg-agent = enabled;
        ssh-agent.enable = lib.mkForce false;
      };

      system = {
        audio = {
          #musnix = enabled;
        };
        boot = {
          grub = enabled;
          plymouth = enabled;
        };
        networking = {
          networkmanager = {
            enable = true;
            hostname = "nebula";
          };
        };
        nix = {
          nh = enabled;
          index = enabled;
          github-access-token = enabled;
        };
        security.sudonopass = enabled;
        services = {
          #fix-8bitdo-ubc = enabled;
          fwupd = enabled;
          #  fix-suspend = enabled;
          #  input-remapper = enabled;
          #  keyring = enabled;
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
      };
    };
  };
}

