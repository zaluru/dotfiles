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
  cfg = config.mine.services.netbird-client;

in
{
  options.mine.services.netbird-client = {
    enable = mkOpt types.bool false "Netbird client - zero trust network vpn";
  };

  config = mkIf cfg.enable {
    services.netbird.clients = {
      main = {
        port = 51821;
        name = "main";
        login = {
          enable = true;
          setupKeyFile = "/run/secrets/netbird-main-setup-key";
          #systemdDependencies = [ "sops-install-secrets.service" ]; # TODO: this for some reason leads to the service failing to authenticate
        };
        openFirewall = true;
        openInternalFirewall = true;
      };
    };

    sops.secrets =
      lib.genAttrs
        [
          "netbird-main-setup-key"
        ]
        (name: {
          owner =
            config.systemd.services.${config.services.netbird.clients.main.service.name}.serviceConfig.User;
          restartUnits = [ "${config.services.netbird.clients.main.service.name}" ];
        });

    systemd.services.${config.services.netbird.clients.main.service.name}.path = [ pkgs.shadow ]; # Required for netbird ssh to work https://github.com/nixos/nixpkgs/issues/505846
  };
}
