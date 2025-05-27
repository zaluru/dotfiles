{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.pcsx2;

in
{
  options.mine.apps.nix-flatpak.pcsx2 = {
    enable = mkEnableOption "Enable pcsx2 flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "net.pcsx2.PCSX2"
      ];
    };
  };
}