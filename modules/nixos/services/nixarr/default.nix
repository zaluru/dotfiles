{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.nixarr;

in
{
  options.mine.services.nixarr = {
    enable = mkOpt types.bool false "nixarr";
  };

# TODO: for now disabled
/*
  imports = [
    inputs.nixarr.nixosModules.default
  ];
  */

  config = mkIf cfg.enable {
    /*
    nixarr = {
      enable = true;
      stateDir = "/data/storage-nvme-0/nixarr/.state";
      mediaDir = "/data/storage-nvme-0/nixarr/media";

      vpn = {
        enable = true;
        wgConf = "/data/storage-nvme-0/nixarr/.secret/wg.conf";
        openTcpPorts = [ 40395 ];
        openUdpPorts = [ 40395 ];
      };

      transmission = {
        enable = true;
        vpn.enable = true;
        peerPort = 40395;
      };

      jellyfin = {
        enable = true;
      };

      bazarr.enable = true;
      lidarr.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sonarr.enable = true;
      jellyseerr.enable = true;
    };
    */
  };
}
