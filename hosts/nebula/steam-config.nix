{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (config.mine) user;

  mangohud = lib.getExe' pkgs.mangohud "mangohud";
  gamemoderun = lib.getExe' pkgs.gamemode "gamemoderun";

  defaults = {
    compatTool = "GE-Proton11-11-x86_64";
    env = {
      LD_PRELOAD = "";
      PROTON_ENABLE_WAYLAND = 1;
    };
    wrappers = [
      mangohud
      gamemoderun
    ];
  };

  games = {
    "1086940" = {
      name = "Baldurs Gate 3";
      compatTool = "GE-Proton11-3";
      args = [
        "--skip-launcher"
        "--vulkan"
      ];
      env = {
        SteamDeck = 0;
        PULSE_LATENCY_MSEC = 60;
      };
    };

    "1874880".name = "Arma Reforger";
    "1062090".name = "Timberborn";
    "892970".name = "Valheim";
    "3393110".name = "AION 2";
  };
in
{
  config.home-manager.users.${user.name} = {
    imports = [ inputs.steam-config-nix.homeModules.default ];

    programs.steam.config = {
      enable = true;
      onSteamRunning = "wait";
      notifications = true;

      apps = lib.mapAttrs (_: lib.recursiveUpdate defaults) games;
    };
  };
}
