{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.scarlett-gui;

in
{
  options.mine.apps.scarlett-gui = {
    enable = mkEnableOption "Install scarlett audio interface gui.";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.unstable.alsa-scarlett-gui
      pkgs.unstable.scarlett2
    ];
  };
}
