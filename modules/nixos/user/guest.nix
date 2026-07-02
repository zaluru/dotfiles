{ lib, config, pkgs, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.user.guest;

in
{
  options.mine.user.guest = {
    enable = mkEnableOption "Enable guest user account.";
  };
  config = mkIf cfg.enable {

    users.groups.guest = { };

    users.users.guest = {
      isNormalUser = true;
      createHome = true;
      uid = 1010;
      group = "guest";
      shell = pkgs.bashInteractive;
    };

    home-manager.users.guest.home.stateVersion = "26.05";
  };
}