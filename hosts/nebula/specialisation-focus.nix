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

  specialisationName = "focus";

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
          };
        };

        apps = {
          firefox.blockedSites = [
            "*://youtube.com/*"
            "*://*.youtube.com/*"
            "*://youtu.be/*"
            "*://*.youtu.be/*"
            "*://reddit.com/*"
            "*://*.reddit.com/*"
            "*://news.ycombinator.com/*"
            "*://discourse.nixos.org/*"
          ];
          brave.enable = lib.mkForce false;
          discord.enable = lib.mkForce false; 
          bruno = enabled;
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
            ## Creative
            trenchbroom = enabled;
            krita = enabled;
            upscayl = enabled;
            blockbench = enabled;
            material-maker = enabled;
            drawy = enabled;
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
