{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak;

in
{
  options.mine.apps.nix-flatpak = {
    enable = mkEnableOption "Enable nix-flatpak - declarative flatpak management.";
    
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    home-manager.users.${user.name} = {
      imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
      services.flatpak = {
        enable = true;
        update.auto.enable = true;
        uninstallUnmanaged = true;
        packages = [
          "com.github.tchx84.Flatseal"
          "org.gtk.Gtk3theme.adw-gtk3"
          "org.gtk.Gtk3theme.adw-gtk3-dark"
        ];
      };
    };
  };
}