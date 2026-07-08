{ lib
, config
, pkgs
, inputs
, ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt enabled;
  inherit (config.mine) user;
  cfg = config.mine.trait.desktop.gaming;

in
{
  options.mine.trait.desktop.gaming = {
    enable = mkOpt types.bool false "Enabled trait - desktop.gaming";
  };

  config = mkIf cfg.enable {
    mine = {
      apps = {
        steam = {
          enable = true;
          hide-games-desktop-entry = true;
        };
        heroic-games-launcher = enabled;
        mangohud = enabled;
      };
      system = {
        boot.ntsync = enabled;
        services = {
          gamemode = enabled;
          gamescope = enabled;
        };
      };
    };
  };
}