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
    ../../overlays/inputs
    (inputs.import-tree ../../modules)
    inputs.nix-private-config.nixosModules.configs
  ];

  config = {
    microvm = {
      hypervisor = "qemu";
      vcpu = 2;
      mem = 3072;

      interfaces = [{
        type = "tap";
        id = "vm-webserver";
        mac = "02:00:00:00:00:11";
      }];

      shares = [{
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }];

      volumes = [{
        image = "var.img";
        mountPoint = "/var";
        size = 10240; # MiB
      }];
    };

    environment.etc."nextcloud-admin-pass".text = "zaq1@WSXzaq1@WSX";
    services.nextcloud = {
      enable = true;
      hostName = "192.168.100.11";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
      config.dbtype = "sqlite";
      settings = {
        maintenance_window_start = 1;
        default_phone_region = "PL";
        log_type = "systemd";
        serverid = 0;
      };
    };

    networking.hostName = "nextcloud-microvm";
    networking.useNetworkd = true;
    networking.firewall.allowedTCPPorts = [ 80 ];

    systemd.network.enable = true;
    systemd.network.networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [ "192.168.100.11/24" "fc00::2/64" ];
        Gateway = [ "192.168.100.10" "fc00::1" ];
        DNS = [ "1.1.1.1" "9.9.9.9" ];
        IPv6AcceptRA = false;
      };
    };

    services.resolved.enable = true;

    system.stateVersion = "26.05";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}