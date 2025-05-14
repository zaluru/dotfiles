{ lib, config, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.services.sunshine;

in
{
  options.mine.services.sunshine = {
    enable = mkEnableOption "Enable Sunshine - game stream host for Moonlight";
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}