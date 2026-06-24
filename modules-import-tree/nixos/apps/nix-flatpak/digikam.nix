{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.digikam;

in
{
  options.mine.apps.nix-flatpak.digikam = {
    enable = mkEnableOption "Enable digikam flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "org.kde.digikam"
      ];
    };
  };
}