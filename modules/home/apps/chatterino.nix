{ lib, config, pkgs, ... }:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.chatterino;

in
{
  options.mine.apps.chatterino = {
    enable = mkEnableOption "Install Chatterino - twitch chat client";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ chatterino2 ];
    };
  };
}