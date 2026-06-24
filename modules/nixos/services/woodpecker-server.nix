{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types mkForce;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.woodpecker-server;

  service-user = config.systemd.services.woodpecker-server.serviceConfig.User;

in
{
  options.mine.services.woodpecker-server = {
    enable = mkOpt types.bool false "Woodpecker server - CI/CD";
    portHTTP = mkOpt types.int 8000 "Port for the HTTP listener";
    portGRPC = mkOpt types.int 9000 "Port for the gRPC listener";
    hostWeb = mkOpt types.str "ci.i.zaluru.com" "FQDN for web interface";
    hostAgent = mkOpt types.str "ci-agent.i.zaluru.com" "FQDN for agent gRPC";
    hostForgejo = mkOpt types.str "git.i.zaluru.com" "FQDN for forgejo instance";
  };

  config = mkIf cfg.enable {

    services.woodpecker-server = {
      enable = true;
      environment = {
        WOODPECKER_HOST = "https://${cfg.hostWeb}";

        WOODPECKER_SERVER_ADDR = ":${toString cfg.portHTTP}";
        WOODPECKER_GRPC_ADDR = ":${toString cfg.portGRPC}";

        WOODPECKER_ADMIN = "zaluru";
        WOODPECKER_REPO_OWNERS = "zaluru";

        WOODPECKER_OPEN = "true";

        WOODPECKER_FORGEJO = "true";
        WOODPECKER_FORGEJO_URL = "https://${cfg.hostForgejo}";
        WOODPECKER_FORGEJO_CLIENT_FILE = "%d/woodpecker-forgejo-client";
        WOODPECKER_FORGEJO_SECRET_FILE = "%d/woodpecker-forgejo-secret"; 

        WOODPECKER_FORCE_IGNORE_SERVICE_FAILURE = "false"; # is true by default. To prepare for v4.0.0, set it to false and update your pipeline definitions if needed."
      };
    };

    systemd.services.woodpecker-server = {
      serviceConfig.LoadCredential = [
        "woodpecker-forgejo-client:${config.sops.secrets.woodpecker-forgejo-client.path}"
        "woodpecker-forgejo-secret:${config.sops.secrets.woodpecker-forgejo-secret.path}"
      ];
      restartTriggers = [
        config.sops.secrets.woodpecker-forgejo-client.path
        config.sops.secrets.woodpecker-forgejo-secret.path
      ];
    };

    sops.secrets.woodpecker-forgejo-client = {};
    sops.secrets.woodpecker-forgejo-secret = {};

    environment.systemPackages = [ pkgs.woodpecker-cli ];

    services.caddy = {
      virtualHosts."${cfg.hostWeb}".extraConfig = ''
        reverse_proxy 127.0.0.1:${toString cfg.portHTTP}
      '';

      virtualHosts."${cfg.hostAgent}".extraConfig = ''
        reverse_proxy h2c://127.0.0.1:${toString cfg.portGRPC}
      '';
    };

  };
}
