{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.container.quadlet-nix.netbird;

in
{
  options.mine.container.quadlet-nix.netbird = {
    enable = mkOpt types.bool false "netbird: mesh vpn.";
    domainName = mkOpt types.str config.mine.defaults.web.domainName "The base domain name.";
    acmeEmail = mkOpt types.str config.mine.defaults.web.acmeEmail "Email used for acme.";
  };

  config = mkIf cfg.enable {
    # TODO: WIP
    virtualisation = {
      quadlet = {

        networks = {
          netbird = {
            rootlessConfig.uid = config.users.users.netbird.uid;
            networkConfig = { };
          };
        };

        containers = {

          netbird-dashboard = {
            rootlessConfig.uid = config.users.users.netbird.uid;
            containerConfig = {
              publishPorts = [
                "127.0.0.1:8080:80"
              ];
              environments = {
                "NETBIRD_MGMT_API_ENDPOINT" = "https://netbird.${cfg.domainName}";
                "NETBIRD_MGMT_GRPC_API_ENDPOINT" = "https://netbird.${cfg.domainName}";
                "NGINX_SSL_PORT" = "443";
                "LETSENCRYPT_DOMAIN" = "none";
                # OIDC - using embedded IdP
                "AUTH_AUDIENCE" = "netbird-dashboard";
                "AUTH_CLIENT_ID" = "netbird-dashboard";
                "AUTH_CLIENT_SECRET" = "";
                "AUTH_AUTHORITY" = "https://netbird.${cfg.domainName}/oauth2";
                "USE_AUTH0" = "false";
                "AUTH_SUPPORTED_SCOPES" = "openid profile email groups";
                "AUTH_REDIRECT_URI" = "/nb-auth";
                "AUTH_SILENT_REDIRECT_URI" = "/nb-silent-auth";
              };
              environmentFiles = [
              ];
              image = "netbirdio/dashboard:latest";
              logDriver = "json-file";
              logOptions = [
                "max-size=500m"
                "max-file=2"
              ];
              name = "netbird-dashboard";
              networks = [
                "netbird.network"
              ];
            };
          };

          netbird-management = {
            rootlessConfig.uid = config.users.users.netbird.uid;
            containerConfig = {
              logDriver = "json-file";
              logOptions = [
                "max-size=500m"
                "max-file=2"
              ];
              name = "netbird-management";
              networks = [
                "netbird.network"
              ];
              publishPorts = [
                "127.0.0.1:8081:80"
              ];
              volumes = [
                "/var/lib/netbird:/var/lib/netbird"
                "/etc/services-secrets/netbird/management.json:/etc/netbird/management.json"
              ];
              exec = [
                "--port"
                "80"
                "--log-file"
                "console"
                "--log-level"
                "info"
                "'--disable-anonymous-metrics=false'"
                "'--single-account-mode-domain=netbird.selfhosted'"
                "'--dns-domain=netbird.selfhosted'"
                "--idp-sign-key-refresh-enabled"
              ];
              image = "netbirdio/management:latest";
            };
          };

          netbird-relay = {
            rootlessConfig.uid = config.users.users.netbird.uid;
            containerConfig = {
              environments = {
                "NB_LOG_LEVEL" = "info";
                "NB_LISTEN_ADDRESS" = ":80";
                "NB_EXPOSED_ADDRESS" = "rels://netbird.${cfg.domainName}:443";
                "NB_AUTH_SECRET" = "";
                "NB_ENABLE_STUN" = "true";
                "NB_STUN_LOG_LEVEL" = "info";
                "NB_STUN_PORTS" = "3478";
              };
              environmentFiles = [
                "/etc/services-secrets/netbird/relay.env"
              ];
              image = "netbirdio/relay:latest";
              logDriver = "json-file";
              logOptions = [
                "max-size=500m"
                "max-file=2"
              ];
              name = "netbird-relay";
              networks = [
                "netbird.network"
              ];
              publishPorts = [
                "127.0.0.1:8084:80"
                "3478:3478/udp"
              ];
            };
          };

          netbird-signal = {
            rootlessConfig.uid = config.users.users.netbird.uid;
            containerConfig = {
              publishPorts = [
                "127.0.0.1:8083:80"
                "127.0.0.1:10000:10000"
              ];
              image = "netbirdio/signal:latest";
              logDriver = "json-file";
              logOptions = [
                "max-size=500m"
                "max-file=2"
              ];
              name = "netbird-signal";
              networks = [
                "netbird.network"
              ];
            };
          };
        };

      };
    };

    security.acme.certs."netbird.${cfg.domainName}".email = "${cfg.acmeEmail}";

    services.nginx = {
      enable = true;

      # Recommended defaults
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = false; # we define explicit headers
      recommendedTlsSettings = true;

      upstreams = {
        netbird_dashboard.servers."127.0.0.1:8080" = { };

        netbird_signal.servers."127.0.0.1:10000" = { };

        netbird_signal_ws.servers."127.0.0.1:8083" = { };

        netbird_management.servers."127.0.0.1:8081" = { };

        netbird_relay.servers."127.0.0.1:8084" = { };
      };

      virtualHosts = {
        "netbird.${cfg.domainName}" = {
          forceSSL = true;
          http2 = true;

          enableACME = true;

          extraConfig = ''
            # Required for long-lived gRPC connections
            client_header_timeout 1d;
            client_body_timeout 1d;

            # Proxy headers
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Scheme $scheme;
            proxy_set_header X-Forwarded-Proto https;
            proxy_set_header X-Forwarded-Host $host;
            grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';

          locations = {
            # Relay (WebSocket)
            "/relay" = {
              proxyPass = "http://netbird_relay";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_read_timeout 1d;
              '';
            };

            # Signal WebSocket
            "/ws-proxy/signal" = {
              proxyPass = "http://netbird_signal_ws";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_read_timeout 1d;
              '';
            };

            # Signal gRPC
            "/signalexchange.SignalExchange/" = {
              extraConfig = ''
                grpc_pass grpc://netbird_signal;
                grpc_read_timeout 1d;
                grpc_send_timeout 1d;
                grpc_socket_keepalive on;
              '';
            };

            # Management API
            "/api/" = {
              proxyPass = "http://netbird_management";
              extraConfig = ''
                proxy_set_header Host $host;
              '';
            };

            # Management WebSocket
            "/ws-proxy/management" = {
              proxyPass = "http://netbird_management";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_read_timeout 1d;
              '';
            };

            # Management gRPC
            "/management.ManagementService/" = {
              extraConfig = ''
                grpc_pass grpc://netbird_management;
                grpc_read_timeout 1d;
                grpc_send_timeout 1d;
                grpc_socket_keepalive on;
              '';
            };

            # Embedded IdP OAuth2
            "/oauth2/" = {
              proxyPass = "http://netbird_management";
              extraConfig = ''
                proxy_set_header Host $host;
              '';
            };

            # Dashboard (catch-all)
            "/" = {
              proxyPass = "http://netbird_dashboard";
            };
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
      3478
      10000
      33080
    ];
    networking.firewall.allowedUDPPorts = [
      3478
      5349
      33080
    ];
    networking.firewall.allowedUDPPortRanges = [
      {
        from = 40000;
        to = 40050;
      }
    ]; # TURN ports

    systemd.tmpfiles.rules = [
      "d /etc/services-secrets/netbird 0750 netbird netbird -"
      "f /etc/services-secrets/netbird/relay.env 0440 netbird netbird -"
      "f /etc/services-secrets/netbird/management.json 0640 netbird netbird -"
      "d /var/lib/netbird 0750 netbird netbird -"
    ];

    users = {
      users.netbird = {
        isSystemUser = true;
        uid = 20000;
        group = "netbird";
        home = "/var/lib/netbird";
        linger = true;
        autoSubUidGidRange = true;
      };

      groups.netbird = {
        gid = 20000;
      };
    };
  };
}
