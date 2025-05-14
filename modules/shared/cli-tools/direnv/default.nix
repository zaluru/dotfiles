{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.direnv;

in
{
  options.mine.cli-tools.direnv = {
    enable = mkEnableOption "Enable direnv";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      xdg.configFile."direnv/direnvrc".source = ./config/direnvrc;
    };
  };
}