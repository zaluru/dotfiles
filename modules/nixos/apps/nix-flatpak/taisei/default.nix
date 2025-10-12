{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.taisei-project;

in
{
  options.mine.apps.nix-flatpak.taisei-project = {
    enable = mkEnableOption "Enable Taisei project flatpak. Taisei is an open clone of the Tōhō Project series.";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "org.taisei_project.Taisei"
      ];
    };
  };
}