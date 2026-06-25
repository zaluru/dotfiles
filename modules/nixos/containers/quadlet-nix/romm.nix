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
  inherit (config.virtualisation.quadlet) containers;
  cfg = config.mine.container.quadlet-nix.romm;

in
{
  options.mine.container.quadlet-nix.romm = {
    enable = mkOpt types.bool false "romm: rom manager.";
    domainName = mkOpt types.str config.mine.defaults.web.domainName "The base domain name.";
    acmeEmail = mkOpt types.str config.mine.defaults.web.acmeEmail "Email used for acme.";
  };

  # TODO: WIP

  config = mkIf cfg.enable {
    virtualisation.quadlet.containers = {
      romm = {
        autoStart = false;
        containerConfig = {
          environments = {
          };
          image = "rommapp/romm:latest";
          name = "romm";
          publishPorts = [
            "127.0.0.1:8090:8080"
          ];
          volumes = [
            "romm_resources:/romm/resources"
            "romm_redis_data:/redis-data"
            "/opt/romm/library:/romm/library"
            "/opt/romm/assets:/romm/assets"
            "/opt/romm/config:/romm/config"
          ];
        };
        unitConfig = {
          Requires = [
            containers.romm-db.ref
            "network-online.target"
          ];
          After = [
            containers.romm-db.ref
            "network-online.target"
          ];
        };
      };

      romm-db = {
        autoStart = false;
        containerConfig = {
          environments = {
            MARIADB_USER = "romm-user";
            MARIADB_DATABASE = "romm";
            MARIADB_PASSWORD = "";
            MARIADB_ROOT_PASSWORD = "";
          };
          notify = "healthy";
          healthCmd = "[\"healthcheck.sh\",\"--connect\",\"--innodb_initialized\"]";
          healthInterval = "10s";
          healthStartPeriod = "30s";
          image = "mariadb:latest";
          name = "romm-db";
          volumes = [
            "romm_mysql_data:/var/lib/mysql"
          ];
          healthRetries = 5;
          healthStartupInterval = "10s";
          healthTimeout = "5s";
        };
      };
    };
  };
  /*
    sops.templates."romm.env".content = ''
      OIDC_PROVIDER = "${config.sops.placeholder.}"
      STEAMGRIDDB_API_KEY = "${config.sops.placeholder.}"
      OIDC_SERVER_APPLICATION_URL = "${config.sops.placeholder.}"
      DB_HOST = "${config.sops.placeholder.romm-db-host}"
      DB_NAME = "${config.sops.placeholder.romm-db-name}"
      DB_PASSWD = "${config.sops.placeholder.romm-db-password}"
      DB_USER = "${config.sops.placeholder.romm-db-user}"
      OIDC_REDIRECT_URI = "${config.sops.placeholder.}"
      ROMM_AUTH_SECRET_KEY = "${config.sops.placeholder.}"
      OIDC_CLIENT_ID = "${config.sops.placeholder.}"
      OIDC_CLIENT_SECRET = "${config.sops.placeholder.}"
      OIDC_ENABLED = "true"
      IGDB_CLIENT_ID = "${config.sops.placeholder.romm-igdb-client-id}"
      IGDB_CLIENT_SECRET = "${config.sops.placeholder.romm-igdb-client-secret}"
      HASHEOUS_API_ENABLED = "true"
    '';
    sops.templates."romm-db.env".content = ''
      password = "${config.sops.placeholder.your-secret}"
    '';
  */
}
