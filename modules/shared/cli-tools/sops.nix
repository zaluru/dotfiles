{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.cli-tools.sops;

in
{
  options.mine.cli-tools.sops = {
    enable = mkEnableOption "sops - Simple and flexible tool for managing secrets";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ sops ];
    };
  };
}
