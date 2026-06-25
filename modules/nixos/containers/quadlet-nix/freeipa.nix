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
  cfg = config.mine.container.quadlet-nix.freeipa-server;

in
{
  options.mine.container.quadlet-nix.freeipa-server = {
    enable = mkOpt types.bool false "netbird: mesh vpn.";
    domainName = mkOpt types.str config.mine.defaults.web.domainName "The base domain name.";
    ipaDomain = mkOpt types.str "EXAMPLE.TEST" "IPA domain";
  };

  # TODO: WIP
  config = mkIf cfg.enable {
    virtualisation = {
      quadlet = {
        containers = {
          freeipa-server-container = {
            rootlessConfig.uid = config.users.users.freeipa.uid;
            containerConfig = {
              image = "quay.io/freeipa/freeipa-server:almalinux-10-4.12.2";
              name = "freeipa-server-container";
              hostname = "${cfg.domainName}";
              exec = [
                "ipa-server-install"
                "-U"
                "-r"
                "${cfg.ipaDomain}"
                "--no-ntp"
              ];
              environmentFiles = [
                "/etc/services-secrets/freeipa/.env"
              ];
              publishPorts = [
                "127.0.0.1:9080:80"
                "127.0.0.1:9443:443"
              ];
              readOnly = true;
              volumes = [
                "/var/lib/freeipa/data:/data:Z"
                "/var/log/freeipa/logs:/var/logs:Z"
              ];
            };
          };
        };
      };
    };

    services.nginx = {
      enable = true;

      # Recommended defaults
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      upstreams = {
        freeipa_dashboard.servers."127.0.0.1:9080" = { };
      };

      virtualHosts = {
        "${cfg.domainName}" = {
          forceSSL = true;
          sslCertificate = "/var/lib/secrets/ssl/${cfg.domainName}.crt";
          sslCertificateKey = "/var/lib/secrets/ssl/${cfg.domainName}.key";
          http2 = true;

          enableACME = false;

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
            "/" = {
              proxyPass = "http://freeipa_dashboard";
            };
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    systemd.tmpfiles.rules = [
      "d /var/log/freeipa 0750 freeipa freeipa -"
      "d /var/lib/freeipa 0750 freeipa freeipa -"
      "d /etc/services-secrets/freeipa 0750 freeipa freeipa -"
      "f /etc/services-secrets/freeipa/.env 0440 freeipa freeipa -"
      # For ssl self signed certs
      "d /var/lib/secrets/ssl/ 0750 nginx nginx -"
      "f /var/lib/secrets/ssl/${cfg.domainName}.crt 0600 nginx nginx -"
      "f /var/lib/secrets/ssl/${cfg.domainName}.key 0400 nginx nginx -"
    ];

    users = {
      users.freeipa = {
        isSystemUser = true;
        uid = 20001;
        group = "freeipa";
        home = "/var/lib/freeipa";
        linger = true;
        autoSubUidGidRange = true;
      };

      groups.freeipa = {
        gid = 20001;
      };
    };
    networking.hosts = {
      "192.168.0.17" = [ "${cfg.domainName}" ];
    };
  };
}
