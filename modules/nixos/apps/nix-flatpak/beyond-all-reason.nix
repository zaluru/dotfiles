{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.beyond-all-reason;

in
{
  options.mine.apps.nix-flatpak.beyond-all-reason = {
    enable = mkEnableOption "Enable beyond all reason flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "info.beyondallreason.bar"
      ];
    };
  };
}