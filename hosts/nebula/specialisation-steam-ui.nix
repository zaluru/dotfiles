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

  specialisationName = "steam-ui";

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
  };
}
