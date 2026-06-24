{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.home-manager.atuin;

in
{
  options.mine.home-manager.atuin = {
    enable = mkEnableOption "Atuin shell history";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.atuin = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        daemon.enable = true;
      };
    };
  };
}