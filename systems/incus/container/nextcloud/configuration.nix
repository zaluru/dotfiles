{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib.zaluru) enabled;
  inherit (config.mine) user;

in
{
  imports = [
    ../../../../overlays/inputs
    (inputs.import-tree ../../../../modules)
    inputs.nix-private-config.nixosModules.configs
  ];

  config = {
    environment.etc."nextcloud-admin-pass".text = "zaq1@WSXzaq1@WSX";
    services.nextcloud = {
      enable = true;
      hostName = "cloud.i.zaluru.com";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
      config.dbtype = "sqlite";
      settings = {
        maintenance_window_start = 1;
        default_phone_region = "PL";
        log_type = "systemd";
        serverid = 0;
      };
    };

    networking.hostName = "nextcloud-incus";
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    system.stateVersion = "26.05";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}