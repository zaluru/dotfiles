{ lib, config, pkgs, ... }:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.keepassxc;

in
{
  options.mine.apps.keepassxc = {
    enable = mkEnableOption "Install keepassxc - password manager.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ keepassxc ];
    };
  };
}