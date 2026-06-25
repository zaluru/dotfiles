{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.upscayl;

in
{
  options.mine.apps.nix-flatpak.upscayl = {
    enable = mkEnableOption "Enable Upscayl flatpak";

  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "org.upscayl.Upscayl"
      ];
    };
  };
}
