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
    programs.gamescope = {
      enable = true;
      # TODO: Aparently it has some problems with bubblewrap so should not be enabled until this issue is solved
      # Might result in performance issues when disabled
      # https://github.com/NixOS/nixpkgs/issues/523200
      capSysNice = false;
    };
  };
}