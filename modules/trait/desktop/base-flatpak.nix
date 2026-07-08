{ lib
, config
, pkgs
, inputs
, ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt enabled;
  inherit (config.mine) user;
  cfg = config.mine.trait.desktop.base-flatpak;

in
{
  options.mine.trait.desktop.base-flatpak = {
    enable = mkOpt types.bool false "Enabled trait - desktop.base-flatpak";
  };

  config = mkIf cfg.enable {
    mine = {
      apps = {
        # INFO: this requires a xdg-desktop-portal to be confiugred.
        # So if I include 'trait.desktop.base' in lets say my steam-ui setup,
        # which does not currently have any portal, it will fail to rebuild.
        # Thats why I have it in a separate trait
        nix-flatpak = {
          enable = true;
          onlyoffice = enabled;
          bitwarden = enabled;
        };
      };
    };
  };
}