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
  cfg = config.mine.services.netbird;

  domain = "zaluru.com";
  netbirdDomain = "netbird.${domain}";
  clientId = "netbird";
in
{
  options.mine.services.netbird = {
    enable = mkOpt types.bool false "Netbird - zero trust network vpn";
  };

  config = mkIf cfg.enable {

    security.acme.certs."netbird.zaluru.com".email = "zaluru@zaluru.com";
    security.acme.acceptTerms = true;

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = false;
      recommendedTlsSettings = true;

      upstreams = {
        netbird_dashboard.servers."127.0.0.1:8080" = {};

        netbird_signal.servers."127.0.0.1:10000" = {};

        netbird_signal_ws.servers."127.0.0.1:8083" = {};

        netbird_management.servers."127.0.0.1:8081" = {};

        netbird_relay.servers."127.0.0.1:8084" = {};
      };

      virtualHosts = {
        "netbird.zaluru.com" = {
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
            "/relay" = {
              proxyPass = "http://netbird_relay";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_read_timeout 1d;
              '';
            };

            "/ws-proxy/signal" = {
              proxyPass = "http://netbird_signal_ws";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_read_timeout 1d;
              '';
            };

            "/signalexchange.SignalExchange/" = {
              extraConfig = ''
                grpc_pass grpc://netbird_signal;
                grpc_read_timeout 1d;
                grpc_send_timeout 1d;
                grpc_socket_keepalive on;
              '';
            };

            "/api/" = {
              proxyPass = "http://netbird_management";
              extraConfig = ''
                proxy_set_header Host $host;
              '';
            };

            "/ws-proxy/management" = {
              proxyPass = "http://netbird_management";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_read_timeout 1d;
              '';
            };

            "/management.ManagementService/" = {
              extraConfig = ''
                grpc_pass grpc://netbird_management;
                grpc_read_timeout 1d;
                grpc_send_timeout 1d;
                grpc_socket_keepalive on;
              '';
            };

            "/oauth2/" = {
              proxyPass = "http://netbird_management";
              extraConfig = ''
                proxy_set_header Host $host;
              '';
            };

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
    ];
  };
}