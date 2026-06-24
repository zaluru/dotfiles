{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.imv;

in
{
  options.mine.apps.imv = {
    enable = mkOpt types.bool false "Install imv image viewer";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ imv ];
      xdg.configFile."imv".source = ./config;
    };
  };
}
