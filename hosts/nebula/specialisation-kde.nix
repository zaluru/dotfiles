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

  specialisationName = "kde";

in

{
  config = {
    specialisation."${specialisationName}".configuration = {
      environment.etc."specialisation".text = "${specialisationName}"; # Required for 'nh' to detect which specialization is currently running https://github.com/nix-community/nh?tab=readme-ov-file#specialisations-support
      system.nixos.tags = [ "with-${specialisationName}" ];
      home-manager.users.${user.name} = {
        specialisation."${specialisationName}".configuration = {
          xdg.dataFile."home-manager/specialisation".text = "${specialisationName}";
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
        system.services = {
          opentabletdriver = enabled;
        };
      };
    };
  };
}
