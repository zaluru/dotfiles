{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.services.gamescope;

in
{
  options.mine.system.services.gamescope = {
    enable = mkEnableOption "Enable gamescope steam compositor";
  };

  config = mkIf cfg.enable {
    programs.gamescope.enable = true;
  };
}