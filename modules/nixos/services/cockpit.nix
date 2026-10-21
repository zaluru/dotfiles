{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.cockpit;

in
{
  options.mine.services.cockpit = {
    enable = mkEnableOption "Enable Cockpit.";
  };

  config = mkIf cfg.enable {
    services.cockpit = {
      enable = true;
      package = pkgs.cockpit;
      plugins = [
        pkgs.cockpit-podman
        pkgs.cockpit-machines
        pkgs.cockpit-files
      ];
      settings = {
        WebService = {
          ProtocolHeader = "X-Forwarded-Proto";
        };
      };
      allowed-origins = [
        "http://localhost:9090"
        "wws://localhost:9090"
        "https://cockpit.${config.mine.system.networking.hostName}.h.zaluru.com"
        "wws://cockpit.${config.mine.system.networking.hostName}.h.zaluru.com"
      ];
    };

    services.caddy.virtualHosts."cockpit.${config.mine.system.networking.hostName}.h.zaluru.com".extraConfig =
      ''
        reverse_proxy http://127.0.0.1:9090 {
          header_up Host {host}
          header_up X-Forwarded-Proto {scheme}
        }
      '';
  };
}
