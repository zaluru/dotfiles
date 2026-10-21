{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.zaluru) mkOpt;
  cfg = config.mine.services.perses;

in
{
  options.mine.services.perses = {
    enable = mkEnableOption "Enable Perses - observability visualization.";
    port = mkOpt types.int 8080 "Web interface port";
    domain = mkOpt types.str "perses.${config.mine.system.networking.hostName}.h.zaluru.com" "Domain under which perses will be available";
  };

  config = mkIf cfg.enable {
    services.perses = {
      enable = true;
      listenAddress = "127.0.0.1";
    };

    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      ''
        reverse_proxy http://127.0.0.1:${toString cfg.port} {
          header_up Host {host}
          header_up X-Forwarded-Proto {scheme}
        }
      '';
  };
}
