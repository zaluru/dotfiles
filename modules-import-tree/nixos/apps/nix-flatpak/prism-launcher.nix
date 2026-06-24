{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.prism-launcher;

in
{
  options.mine.apps.nix-flatpak.prism-launcher = {
    enable = mkEnableOption "Enable prism-launcher flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "org.prismlauncher.PrismLauncher"
      ];
    };
  };
}