{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let

  inherit (config.mine) user;

  mangohud = (lib.getExe' pkgs.mangohud "mangohud");
  gamemoderun = (lib.getExe' pkgs.gamemode "gamemoderun");

in

{

  config = {
    home-manager.users.${user.name} = { lib, ... }: {

      imports = [
        inputs.steam-config-nix.homeModules.default
      ];

      programs.steam.config = {
        enable = true;
        onSteamRunning = "wait";
        notifications = true;
        #defaultCompatTool = "GE-Proton";

        apps = {
          "1086940" = {
            name = "Baldurs Gate 3";
            compatTool = "GE-Proton11-3";
            args = [
              "--skip-launcher"
              "--vulkan"
            ];
            env = {
              SteamDeck = 0;
              LD_PRELOAD = "";
              PROTON_ENABLE_WAYLAND = 1;
              PULSE_LATENCY_MSEC = 60;
            };
            wrappers = [
              mangohud
              gamemoderun
            ];
          };
          "1874880" = {
            name = "Arma Reforger";
            compatTool = "GE-Proton11-3";
            env = {
              LD_PRELOAD = "";
              PROTON_ENABLE_WAYLAND = 1;
            };
            wrappers = [
              mangohud
              gamemoderun
            ];
          };
        };
      };
    };
  };
}
