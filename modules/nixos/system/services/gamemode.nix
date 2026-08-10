{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.services.gamemode;

in
{
  options.mine.system.services.gamemode = {
    enable = mkEnableOption "Enable gamemode daemon for games requesting temporary system optimisations";
  };

  config = mkIf cfg.enable {
    # https://nixos.wiki/wiki/Gamemode
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          desiredgov = "performance";
          desiredprof = "performance";
          renice = 11;
          inhibit_screensaver = 0;
        };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
    users.users.${user.name}.extraGroups = mkIf user.enable [ "gamemode" ];
  };
}
