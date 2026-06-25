{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.bottles;

in
{
  options.mine.apps.nix-flatpak.bottles = {
    enable = mkEnableOption "Enable bottles flatpak";

  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "com.usebottles.bottles"
      ];
    };
  };
}
