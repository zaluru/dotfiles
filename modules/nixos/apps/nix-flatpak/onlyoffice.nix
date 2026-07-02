{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.onlyoffice;

in
{
  options.mine.apps.nix-flatpak.onlyoffice = {
    enable = mkEnableOption "Enable onlyoffice flatpak";

  };

  # TODO: move to euro-office when available as a desktop app.
  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "org.onlyoffice.desktopeditors"
      ];
    };
  };
}
