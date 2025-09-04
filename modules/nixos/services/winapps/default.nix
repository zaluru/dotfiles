{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.winapps;

in
{
  options.mine.services.winapps = {
    enable = mkOpt types.bool false "winapps";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.winapps.winapps
      pkgs.winapps.winapps-launcher
      pkgs.unstable.freerdp
    ];
  };
}
