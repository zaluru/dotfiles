{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.rpcs3;

in
{
  options.mine.apps.nix-flatpak.rpcs3 = {
    enable = mkEnableOption "Enable rpcs3 flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "net.rpcs3.RPCS3"
      ];
    };
  };
}