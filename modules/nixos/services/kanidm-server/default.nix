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

    # Currently not able to set the system image from nixos configuration, had to run:
    # kanidm system domain set-image ~/downloads/multifactor-authenticator.svg

    services.kanidm = {
      package = lib.mkDefault pkgs.kanidmWithSecretProvisioning_1_10;
      server = {
        enable = true;

        settings = {
          domain = "${cfg.domainIdm}";
          origin = "https://${cfg.domainIdm}";
          trust_x_forward_for = true;

          bindaddress = "127.0.0.1:${toString cfg.portIdm}";
          ldapbindaddress = "0.0.0.0:${toString cfg.portLdap}";

          tls_key = "${certDirectory}/key.pem";
          tls_chain = "${certDirectory}/fullchain.pem";
        };

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

        groups = {
          proxmox_users = {
            members = [ ];
          };
          proxmox_admins = {
            members = [ "zaluru" ];
          };
          forgejo_users = {
            members = [ ];
          };
          forgejo_admins = {
            members = [ "zaluru" ];
          };
          forgejo_restricted = {
            members = [ ];
          };
        };

        systems.oauth2 = {
          proxmox = {
            present = true;
            imageFile = "${inputs.dashboard-icons}/proxmox.svg";
            preferShortUsername = true;
            displayName = "Proxmox";
            originUrl = "https://pve.i.zaluru.com";
            originLanding = "https://pve.i.zaluru.com";
            basicSecretFile = config.sops.secrets.kanidm-oauth2-proxmox-secret.path;
            scopeMaps = {
              proxmox_users = ["openid" "email" "profile" "groups"];
              proxmox_admins = ["openid" "email" "profile" "groups"];
            };
            claimMaps.proxmox_groups = {
              joinType = "array";
              valuesByGroup = {
                proxmox_users = ["user"];
                proxmox_admins = ["admin"];
              };
            };
          };

          forgejo = {
            present = true;
            imageFile = "${inputs.dashboard-icons}/forgejo.svg";
            preferShortUsername = true;
            displayName = "Forgejo";
            originUrl = "https://git.i.zaluru.com/user/oauth2/kanidm/callback";
            originLanding = "https://git.i.zaluru.com/user/oauth2/kanidm";
            basicSecretFile = config.sops.secrets.kanidm-oauth2-forgejo-secret.path;
            scopeMaps = {
              forgejo_users = ["openid" "email" "profile" "groups"];
              forgejo_admins = ["openid" "email" "profile" "groups"];
              forgejo_restricted  = ["openid" "email" "profile" "groups"];
            };
            claimMaps.forgejo_groups = {
              joinType = "array";
              valuesByGroup = {
                forgejo_users = ["user"];
                forgejo_admins = ["admin"];
                forgejo_restricted = ["restricted"];
              };
            };
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
          "kanidm-oauth2-proxmox-secret"
          "kanidm-oauth2-forgejo-secret"
        ]
        (name: {
          owner = "kanidm";
          group = "kanidm";
        });
  };
}
