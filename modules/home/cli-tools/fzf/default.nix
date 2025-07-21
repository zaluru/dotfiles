{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.home-manager.fzf;

in
{
  options.mine.home-manager.fzf = {
    enable = mkEnableOption "Fzf configs";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.fzf = {
        enable = true;
        colors = {
          "fg" = "#ffffff";
          "bg" = "#161616";
          "hl" = "#08bdba";
          "fg+" = "#f2f4f8";
          "bg+" = "#262626";
          "hl+" = "#3ddbd9";
          "info" = "#78a9ff";
          "prompt" = "#33b1ff";
          "pointer" = "#42be65";
          "marker" = "#ee5396";
          "spinner" = "#ff7eb6";
          "header" = "#be95ff";
        };
      };
    };
  };
}