{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.bitwarden;

in
{
  options.mine.apps.nix-flatpak.bitwarden = {
    enable = mkEnableOption "Enable bitwarden password manager flatpak";

  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "com.bitwarden.desktop"
      ];
    };
  };
}
