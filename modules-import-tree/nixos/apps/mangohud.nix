{ lib, config, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.mangohud;

in
{
  options.mine.apps.mangohud = {
    enable = mkOpt types.bool false "Enable Mangohud";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.mangohud = {
        enable = true;
      };
    };
  };
}