{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.drawy;

in
{
  options.mine.apps.nix-flatpak.drawy = {
    enable = mkEnableOption "Enable drawy - infinite canvas app.";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "org.kde.drawy"
      ];
    };
  };
}