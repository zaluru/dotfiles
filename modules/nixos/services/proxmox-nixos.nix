{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.proxmox-nixos;

in
{
  options.mine.services.proxmox-nixos = {
    enable = mkOpt types.bool false "Proxmox hypervisor on NixOS";
  };

  imports = [
    inputs.proxmox-nixos.nixosModules.proxmox-ve
  ];

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.proxmox-nixos.overlays.x86_64-linux # TODO: fix hardcoded value
    ];

    services.proxmox-ve = {
      enable = true;
      ipAddress = "100.115.215.147";
    };

    #TODO: consider changing the root CA of proxmox
    #https://forum.proxmox.com/threads/proxmox-ui-caddy-and-reverse-proxy.83198/
    services.caddy.virtualHosts."pve.i.zaluru.com".extraConfig = ''
      reverse_proxy 100.115.215.147:8006 {
        transport http {
          tls_trust_pool file /etc/caddy/pve-root-ca.pem # Path to PVE root cert
        }
      }
    '';

    systemd.tmpfiles.rules = [
      "C /etc/caddy/pve-root-ca.pem 0400 caddy caddy - /etc/pve/pve-root-ca.pem"
    ];


    # Make vmbr0 bridge visible in Proxmox web interface
    services.proxmox-ve.bridges = [ "vmbr0" ];

    # Actually set up the vmbr0 bridge
    systemd.network.networks."10-lan" = {
      matchConfig.Name = [ "en01" ];
      networkConfig = {
        Bridge = "vmbr0";
      };
    };

    systemd.network.netdevs."vmbr0" = {
      netdevConfig = {
        Name = "vmbr0";
        Kind = "bridge";
      };
    };

    systemd.network.networks."10-lan-bridge" = {
      matchConfig.Name = "vmbr0";
      networkConfig = {
        IPv6AcceptRA = true;
        DHCP = "ipv4";
      };
      linkConfig.RequiredForOnline = "routable";
    };

  };
}
