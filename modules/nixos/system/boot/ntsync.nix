{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.mine.system.boot.ntsync;

in
{
  options.mine.system.boot.ntsync = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''Enables NTSYNC kernel module.

      https://wiki.archlinux.org/title/Wine#NTSync
      In-kernel implementation of synchronization primitives. 
      More closely translates the behavior of the Microsoft Windows NT kernel.
      You can verify that it's being used with running a game with 'PROTON_LOG=1' and searching in the log for 'ntsync'.
      You can disable it by setting the environment variable 'PROTON_NO_NTSYNC=1'
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "ntsync" ];
  };
}
