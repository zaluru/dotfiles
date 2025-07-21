{ lib, config, pkgs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.nix-flatpak.trenchbroom;

in
{
  options.mine.apps.nix-flatpak.trenchbroom = {
    enable = mkOpt types.bool false "Enable Trenchbroom";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "com.kristianduske.TrenchBroom"
      ];
    };
  };
}