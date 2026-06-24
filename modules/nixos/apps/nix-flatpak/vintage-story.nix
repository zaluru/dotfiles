{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.vintage-story;

in
{
  options.mine.apps.nix-flatpak.vintage-story = {
    enable = mkEnableOption "Enable vintage story flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "at.vintagestory.VintageStory"
      ];
    };
  };
}