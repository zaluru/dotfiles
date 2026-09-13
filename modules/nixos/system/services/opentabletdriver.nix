{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.system.services.opentabletdriver;

in
{
  options.mine.system.services.opentabletdriver = {
    enable = mkEnableOption "Enable opentabletdriver";
  };

  config = mkIf cfg.enable {
    # For my Huion Inspiroy Dial Q620M

    # https://wiki.nixos.org/wiki/OpenTabletDriver
    hardware = {
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
      uinput.enable = true;
    };
    boot.kernelModules = [ "uinput" ];
  };
}