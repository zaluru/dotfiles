{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.material-maker;

in
{
  options.mine.apps.nix-flatpak.material-maker = {
    enable = mkEnableOption "Enable material-maker flatpak: procedural texture generation and mesh painting tool";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "io.github.RodZill4.Material-Maker"
      ];
    };
  };
}
