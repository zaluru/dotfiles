{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkIf;
  cfg = config.mine.user.shell.starship;
  inherit (config.mine) user;
  starship_config = import ../../../nixos/user/starship.nix {
    inherit config;
    inherit lib;
  };

in
{
  config = mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    home-manager.users.${user.name} = starship_config;
  };
}
