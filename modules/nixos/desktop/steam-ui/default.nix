{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.desktop.steam-ui;

in
{
  options.mine.desktop.steam-ui = {
    enable = mkOpt types.bool false "steam-ui desktop";
  };

  imports = [
    inputs.jovian.nixosModules.default
  ];

  config = mkIf cfg.enable {
    jovian = {
      steam = {
        enable = true;
        autoStart = true;
        user = "${user.name}";
      };
      hardware.has.amd.gpu = true;
      hardware.amd.gpu.enableEarlyModesetting = true;
    };
  };
}
