{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.shadps4;

in
{
  options.mine.apps.nix-flatpak.shadps4 = {
    enable = mkEnableOption "Enable shadps4 flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "net.shadps4.shadPS4"
      ];
    };
  };
}