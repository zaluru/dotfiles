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
  cfg = config.mine.services.kanidm-server;
  certDirectory = config.security.acme.certs."${cfg.domainIdm}".directory;

in
{
  options.mine.services.kanidm-server = {
    enable = mkOpt types.bool false "Kanidm server - simple identity management platform.";
    domainIdm = mkOpt types.str "idm.i.zaluru.com" "Domain on which the kanidm will be available";
    domainLdap =
      mkOpt types.str "ldap.i.zaluru.com"
        "Domain on which the kanidm ldap will be available";
    portLdap = mkOpt types.int 636 "LDAP port";
    portIdm = mkOpt types.int 8443 "IDM port";
  };

  config = mkIf cfg.enable {
    services.kanidm = {
      package = lib.mkDefault pkgs.kanidmWithSecretProvisioning_1_10;
      enableServer = true;
      serverSettings = {
        domain = "${cfg.domainIdm}";
        origin = "https://${cfg.domainIdm}";
        trust_x_forward_for = true;

        bindaddress = "127.0.0.1:${toString cfg.portIdm}";
        ldapbindaddress = "0.0.0.0:${toString cfg.portLdap}";

        tls_key = "${certDirectory}/key.pem";
        tls_chain = "${certDirectory}/fullchain.pem";
      };

      provision = {
        enable = true;
        autoRemove = true;

        adminPasswordFile = config.sops.secrets.kanidm-admin-password.path;
        idmAdminPasswordFile = config.sops.secrets.kanidm-idm-admin-password.path;

        persons = {
          zaluru = {
            displayName = "zaluru";
            legalName = "zaluru";
            mailAddresses = [ "zaluru@zaluru.com" ];
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.portLdap ];

    services.caddy = {
      enable = true;
      virtualHosts."${cfg.domainIdm}".extraConfig = ''
        tls "${certDirectory}/fullchain.pem" "${certDirectory}/key.pem"
        reverse_proxy ${config.services.kanidm.provision.instanceUrl} {
          header_up Host {host}
          header_up X-Real-IP {remote_host}

          transport http {
              tls_server_name ${cfg.domainIdm}
          }
        }
      '';
    };

    users.groups."kanidm-certs".members = [
      "caddy"
      "kanidm"
    ];

    security.acme.certs."${cfg.domainIdm}" = {
      dnsProvider = "bunny";
      domain = "${cfg.domainIdm}";
      extraDomainNames = [ "${cfg.domainLdap}" ];
      group = "kanidm-certs";
      credentialFiles = {
        "BUNNY_API_KEY_FILE" = config.sops.secrets.acme-bunny-net-api-key.path;
      };
      reloadServices = [
        "caddy.service"
        "kanidm.service"
      ];
    };

    sops.secrets = {
      acme-bunny-net-api-key = {
        key = "bunny-net-api-key";
        group = config.security.acme.certs."${cfg.domainIdm}".group;
      };
    }
    //
      lib.genAttrs
        [
          "kanidm-admin-password"
          "kanidm-idm-admin-password"
        ]
        (name: {
          owner = "kanidm";
          group = "kanidm";
        });
  };
}
