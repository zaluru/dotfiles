{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.ente-auth;

in
{
  options.mine.apps.nix-flatpak.ente-auth = {
    enable = mkEnableOption "Enable ente auth 2FA app";

  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "io.ente.auth"
      ];
    };
  };
}
