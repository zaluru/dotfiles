{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.home-manager.presenterm;

in
{
  options.mine.home-manager.presenterm = {
    enable = mkEnableOption "Presenterm - markdown presentations in terminal";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs.unstable; [ presenterm ];
    };
  };
}