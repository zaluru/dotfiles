{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.netbird;

  domain = "zaluru.com";
  netbirdDomain = "netbird.${domain}";
  clientId = "351215990983426049";
in
{
# https://lukadeka.com/blog/setting-up-netbird-with-zitadel-on-nixos/
  options.mine.services.netbird = {
    enable = mkOpt types.bool false "Netbird - zero trust network vpn";
  };

  config = mkIf cfg.enable {
    # TODO: WIP

    services.netbird.server = {
      enable = true;
      enableNginx = true;
      domain = netbirdDomain;

      coturn = {
        enable = true;
        domain = netbirdDomain;
        passwordFile = "/etc/netbird-current/turn_password";
      };

      signal = {
        enable = true;
        enableNginx = true;
        domain = netbirdDomain;
      };

      dashboard = {
        enable = true;
        enableNginx = true;
        domain = netbirdDomain;
        settings = {
          AUTH_AUTHORITY = "https://auth.${domain}";
          AUTH_CLIENT_ID = clientId;
          AUTH_AUDIENCE = clientId;
        };
      };

      management = {
        enable = true;
        enableNginx = true;
        domain = netbirdDomain;
        turnDomain = netbirdDomain;
        singleAccountModeDomain = netbirdDomain;
        oidcConfigEndpoint = "https://auth.${domain}/.well-known/openid-configuration";

        settings = {
          Signal.URI = "${netbirdDomain}:443";

          HttpConfig.AuthAudience = clientId;
          IdpManagerConfig.ClientConfig.ClientID = clientId;
          DeviceAuthorizationFlow.ProviderConfig = {
            Audience = clientId;
            ClientID = clientId;
          };
          PKCEAuthorizationFlow.ProviderConfig = {
            Audience = clientId;
            ClientID = clientId;
          };

          TURNConfig = {
            Secret._secret = "/etc/netbird-current/turn_password";
            CredentialsTTL = "12h";
            TimeBasedCredentials = false;
            Turns = [
              {
                Password._secret = "/etc/netbird-current/turn_password";
                Proto = "udp";
                URI = "turn:${netbirdDomain}:3478";
                Username = "netbird";
              }
            ];
          };
          Relay = {
            Addresses = [ "rels://${netbirdDomain}:33080" ];
            CredentialsTTL = "24h";
            Secret._secret = "/etc/netbird-current/relay_secret";
          };
          DataStoreEncryptionKey._secret = "/etc/netbird-current/data_store_encryption_key";
        };
      };
    };

    # Make the env available to the systemd service
    systemd.services.netbird-management.serviceConfig = {
      EnvironmentFile = "/etc/netbird-current/setup.env";
    };

    # Override ACME settings to get a cert
    services.nginx.virtualHosts = lib.mkMerge [
      {
        "${netbirdDomain}" = {
          enableACME = true;
          forceSSL = true;
        };
      }
    ];

    # Run the Netbird relay with TLS to allow relaying over TCP
    virtualisation.oci-containers.containers.netbird-relay = {
      image = "netbirdio/relay:latest";
      ports = [
        "33080:33080"
      ];
      volumes = [
        "/var/lib/acme/${netbirdDomain}/:/certs:ro"
      ];
      environment = {
        NB_LOG_LEVEL = "info";
        NB_LISTEN_ADDRESS = ":33080";
        NB_EXPOSED_ADDRESS = "rels://${netbirdDomain}:33080";
        NB_TLS_CERT_FILE = "/certs/fullchain.pem";
        NB_TLS_KEY_FILE = "/certs/key.pem";
      };
      environmentFiles = [
        "/etc/netbird-current/relay_secret_container"
        "/etc/netbird-current/setup.env"
      ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--cap-add=SYS_ADMIN"
        "--cap-add=SYS_RESOURCE"
      ];
    };

    networking.firewall.allowedTCPPorts = [ 80 443 3478 10000 33080 ];
    networking.firewall.allowedUDPPorts = [ 3478 5349 33080 ];
    networking.firewall.allowedUDPPortRanges = [{
      from = 40000;
      to = 40050;
    }]; # TURN ports
  };
}
