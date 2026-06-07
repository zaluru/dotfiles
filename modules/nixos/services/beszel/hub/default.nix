{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.zaluru) mkOpt;
  cfg = config.mine.services.beszel.hub;
in
{
  options.mine.services.beszel.hub = {
    enable = mkEnableOption "Enable Beszel, a lightweight server monitoring platform";
    dataDir = mkOpt types.path "/opt/configs/beszel-hub" "Path for stored data.";
    listenAddress = mkOpt types.str "127.0.0.1" "Address on which to start Beszel Hub webserver.";
    domain = mkOpt types.str "mon.i.zaluru.com" "FQDN for the Beszel Hub instance";
    port = mkOpt types.port 8090 "Port for Beszel Hub webserver.";
  };

  config = mkIf cfg.enable {
    services.beszel.hub = {
      enable = true;
      host = "${cfg.listenAddress}";
      port = cfg.port;
      environment = {
        APP_URL = "https://${cfg.domain}";
        USER_CREATION = "true"; # Creates OAUTH2 users
        # TODO: Change to this when USER_EMAIL and USER_PASSWORD accept a file
        #USER_EMAIL_FILE = "%d/beszel-initial-user-email"; # Somethings fucked i don't know why it does not accept the email 
        #USER_PASSWORD_FILE = "%d/beszel-initial-user-password";
        DISABLE_PASSWORD_AUTH = "true";
      };
    };


    systemd.services.beszel-hub = {
    # TODO: Change to this when USER_EMAIL and USER_PASSWORD accept a file
    #  serviceConfig.LoadCredential = [
    #    "beszel-initial-user-email:${config.sops.secrets.beszel-initial-user-email.path}"
    #    "beszel-initial-user-password:${config.sops.secrets.beszel-initial-user-password.path}"
    #  ];
      serviceConfig.EnvironmentFile = config.sops.templates."beszel-hub-secrets-env".path;
      restartTriggers = [
        config.sops.secrets.beszel-initial-user-email.path
        config.sops.secrets.beszel-initial-user-password.path
      ];
    };

    sops.secrets.beszel-initial-user-email = {};
    sops.secrets.beszel-initial-user-password = {};

    sops.templates."beszel-hub-secrets-env" = {
      content = ''
        USER_EMAIL=${config.sops.placeholder.beszel-initial-user-email}
        USER_PASSWORD=${config.sops.placeholder.beszel-initial-user-password}
      '';
    };

    services.caddy = {
      virtualHosts."${cfg.domain}".extraConfig = ''
        request_body {
          max_size 10MB
        }
        reverse_proxy ${cfg.listenAddress}:${toString cfg.port} {
          transport http {
            read_timeout 360s
          }
        }
      '';
    };
  };
}