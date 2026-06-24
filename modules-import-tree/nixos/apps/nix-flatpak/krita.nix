{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.krita;

in
{
  options.mine.apps.nix-flatpak.krita = {
    enable = mkEnableOption "Enable krita flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "org.kde.krita"
      ];
    };
  };
}