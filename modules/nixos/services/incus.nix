{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkIf types mkForce;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.incus;

in
{
  options.mine.services.incus = {
    enable = mkOpt types.bool false "Incus";
    portHTTP = mkOpt types.int 8888 "Port for the HTTPS listener";
  };

  config = mkIf cfg.enable {

    virtualisation.incus = {
      enable = true;
      ui.enable = true;

      package = pkgs.incus;
      ui.package = pkgs.unstable.incus-ui-canonical;

      # To restart incus instant and allow pressed run:
      # sudo systemctl stop incus.service incus.socket incus-preseed.service
      # sudo rm -r /var/lib/incus
      preseed = {
        config = {
          "core.https_address" =
            "incus.${config.mine.system.networking.hostName}.h.zaluru.com:8888";

          # BEGIN TLS
          # On client device
          ## Enter the web ui
          ## Proceed with instruction, download crt and pfx
          ## Copy .crt to incus server
          ## scp ~/downloads/incus-ui.crt zaluru@blazar:/home/zaluru/incus-ui.crt
          ## in firefox go to: about:preferences
          ## search for manage certificates
          ## Enter your certificates
          ## Press import
          ## import the ~/downloads/incus-ui.pfx
          ## Restart firefox

          # on server device
          ## incus config trust add-certificate incus-ui.crt

          # On client device
          ## Enter the web ui, firefox will ask you if you want it to send the certificate
          ## Set Remember this decision to permamently
          ## press ok
          ## YOU ARE IN INCUSE WEB UI :D

          # END TLS AUTH

          #"oidc.issuer" = "https://idm.i.zaluru.com/ui/oauth2";
          #"oidc.client.id" = "incus-blazar";
          # TODO: Not sure if this will get accepted with sops
          # "oidc.client.secret" = "";
          # Currently setting it like so:
          # incus config set oidc.client.secret - < /run/secrets/kanidm-oauth2-incus-blazar-secret
          # TODO: hmm lxd supports this but incus does not :C
          # Requires this feature in kanidm: https://github.com/kanidm/kanidm/issues/1523
        };
        networks = [
          {
            config = {
              "ipv4.address" = "10.0.100.1/24";
              "ipv4.nat" = "true";
            };
            name = "incusbr0";
            type = "bridge";
          }
        ];
        profiles = [
          {
            devices = {
              eno1 = {
                name = "eno1";
                network = "incusbr0";
                type = "nic";
              };
              root = {
                path = "/";
                pool = "default";
                #size = "35GiB";
                type = "disk";
              };
            };
            name = "default";
          }
        ];
        storage_pools = [
          {
            config = {
              source = "/var/lib/incus/storage-pools/default";
            };
            driver = "dir";
            name = "default";
          }
        ];
      };
    };

    networking.nftables.enable = true;
    networking.firewall.interfaces.incusbr0.allowedTCPPorts = [
      53
      67
      8888 # Incus
    ];
    networking.firewall.interfaces.incusbr0.allowedUDPPorts = [
      53
      67
      8888 # Incus
    ];

    users.users."zaluru".extraGroups = [ "incus-admin" ];

    sops.secrets."kanidm-oauth2-incus-${config.mine.system.networking.hostName}-secret" =
      { };

    networking.firewall.allowedTCPPorts = [ 8888 ];
  };
}
