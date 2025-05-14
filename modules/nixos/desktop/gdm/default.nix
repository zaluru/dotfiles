{ lib, config, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.desktop.gdm;

in
{
  options.mine.desktop.gdm = {
    enable = mkOpt types.bool false "Enable GDM display manager";
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}