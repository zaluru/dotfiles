{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.zaluru) mkOpt;
  cfg = config.mine.services.beszel.agent;
in
{
  options.mine.services.beszel.agent = {
    enable = mkEnableOption "Enable Beszel, a lightweight server monitoring platform";
    port = mkOpt types.port 45876 "Port the Agent runs on.";
    hubDomain = mkOpt types.str "mon.i.zaluru.com" "FQDN for the Beszel Hub instance";
  };

  config = mkIf cfg.enable {
    services.beszel.agent = {
      enable = true;
      smartmon.enable = true;
      environment = {
        HUB_URL = "https://${cfg.hubDomain}";
        KEY_FILE = "%d/beszel-agent-public-key";
        TOKEN_FILE = "%d/beszel-agent-websocket-token";
      };

      openFirewall = true;
    };

    systemd.services.beszel-agent = {
      serviceConfig.LoadCredential = [
        "beszel-agent-public-key:${config.sops.secrets.beszel-agent-public-key.path}"
        "beszel-agent-websocket-token:${config.sops.secrets.beszel-agent-websocket-token.path}"
      ];
      restartTriggers = [
        config.sops.secrets.beszel-agent-public-key.path
        config.sops.secrets.beszel-agent-websocket-token.path
      ];
    };

    sops.secrets.beszel-agent-public-key = { };
    sops.secrets.beszel-agent-websocket-token = { };
  };
}
