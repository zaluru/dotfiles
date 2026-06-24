{ lib, config, pkgs, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.thunderbird;

in
{
  options.mine.apps.thunderbird = {
    enable = mkEnableOption "Install Thunderbird";
  };

  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
    };
  };
}