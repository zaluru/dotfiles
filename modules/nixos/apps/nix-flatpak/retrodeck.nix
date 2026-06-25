{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.retrodeck;

in
{
  options.mine.apps.nix-flatpak.retrodeck = {
    enable = mkEnableOption "Enable RetroDECK - All-in-one Retro Gaming Platform";

  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "net.retrodeck.retrodeck"
      ];
    };
  };
}
