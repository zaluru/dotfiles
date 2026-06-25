{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.proton-plus;

in
{
  options.mine.apps.nix-flatpak.proton-plus = {
    enable = mkEnableOption "Enable ProtonPlus flatpak, compatibility tools manager";

  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "com.vysp3r.ProtonPlus"
      ];
    };
  };
}
