{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types mkForce;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.woodpecker-server;

in
{
  options.mine.services.woodpecker-server = {
    enable = mkOpt types.bool false "Woodpecker server - CI/CD";
    port = mkOpt types.int 8000 "Port for the web interface";
    host = mkOpt types.str "ci.i.zaluru.com" "FQDN for web interface";
    forgejoHost = mkOpt types.str "git.i.zaluru.com" "FQDN for forgejo instance";
  };

  config = mkIf cfg.enable {

    services.woodpecker-server = {
      enable = true;
      environment = {
        WOODPECKER_HOST = "https://${cfg.host}";
        WOODPECKER_SERVER_ADDR = "${toString cfg.port}";
        WOODPECKER_ADMIN = "admin-zaluru";
        WOODPECKER_REPO_OWNERS = "zaluru";
        WOODPECKER_FORGEJO = true;
        WOODPECKER_FORGEJO_URL = "https://${cfg.forgejoHost}";
        WOODPECKER_FORGEJO_CLIENT_FILE = config.sops.secrets.woodpecker-forgejo-client.path;
        WOODPECKER_FORGEJO_SECRET_FILE = config.sops.secrets.woodpecker-forgejo-secret.path;
      };
    };

    sops.secrets.woodpecker-forgejo-client.owner = "woodpecker";
    sops.secrets.woodpecker-forgejo-secret.owner = "woodpecker";

    environment.systemPackages = [ pkgs.woodpecker-cli ];

    services.caddy.virtualHosts."wp.i.zaluru.com".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';

  };
}
