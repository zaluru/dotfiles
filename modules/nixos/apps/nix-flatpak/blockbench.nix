{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.blockbench;

in
{
  options.mine.apps.nix-flatpak.blockbench = {
    enable = mkEnableOption "Enable blockbench flatpak";

  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "net.blockbench.Blockbench"
      ];
    };
  };
}
