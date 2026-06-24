{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.waydroid;

in
{
  options.mine.apps.waydroid = {
    enable = mkEnableOption "waydroid";
  };

  config = lib.mkIf cfg.enable {

    virtualisation.waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };

    environment.systemPackages =  [ pkgs.waydroid-helper ];

    systemd = {
      packages = [ pkgs.waydroid-helper ];
      services.waydroid-mount.wantedBy = [ "multi-user.target" ];
    };

  };
}