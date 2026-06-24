{ lib, config, pkgs, ... }:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.signal-desktop;

in
{
  options.mine.apps.signal-desktop = {
    enable = mkEnableOption "Install Signal - encrypted chat.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs.unstable; [ signal-desktop ];
    };
  };
}