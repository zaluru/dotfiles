{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.heroic-games-launcher;

  heroic-custom = pkgs.heroic.override {
    extraPkgs = pkgs': with pkgs'; [
      gamescope
      gamemode
    ];
  };
in
{
  options.mine.apps.heroic-games-launcher = {
    enable = mkEnableOption "Enabled heroic games launcher";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      heroic-custom
    ];
  };
}
