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

  # cockpit service in 25.11 dose not have the plugins option
  disabledModules = [
    "services/monitoring/cockpit.nix"
  ];

  imports = [
    "${inputs.unstable}/nixos/modules/services/monitoring/cockpit.nix"
  ];

  config = mkIf cfg.enable {
    services.cockpit = {
      enable = true;
      package = pkgs.unstable.cockpit;
      plugins = [
        pkgs.unstable.cockpit-podman
        pkgs.unstable.cockpit-machines
        pkgs.unstable.cockpit-files
      ];
      settings = {
        WebService = {
          ProtocolHeader = "X-Forwarded-Proto";
        };
      };
      allowed-origins = [
        "http://localhost:9090"
        "wws://localhost:9090"
        "https://cockpit.${config.mine.system.networking.networkmanager.hostname}.h.zaluru.com"
        "wws://cockpit.${config.mine.system.networking.networkmanager.hostname}.h.zaluru.com"
      ];
    };

    services.caddy.virtualHosts."cockpit.${config.mine.system.networking.networkmanager.hostname}.h.zaluru.com".extraConfig =
      ''
        reverse_proxy http://127.0.0.1:9090 {
          header_up Host {host}
          header_up X-Forwarded-Proto {scheme}
        }
      '';
  };
}
