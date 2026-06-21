{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.heroic-games-launcher;

in
{
  options.mine.apps.nix-flatpak.heroic-games-launcher = {
    enable = mkEnableOption "Enable heroic games launcher flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "com.heroicgameslauncher.hgl"
      ];
    };
  };
}