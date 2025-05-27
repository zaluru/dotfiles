{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.duckstation;

in
{
  options.mine.apps.nix-flatpak.duckstation = {
    enable = mkEnableOption "Enable duckstation flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "org.duckstation.DuckStation"
      ];
    };
  };
}