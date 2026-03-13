{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.container.quadlet-nix.netbird;

in
{
  options.mine.services.personal-website = {
    enable = mkOpt types.bool false "Enable the personal website";
    domainName = mkOpt types.str config.mine.defaults.web.domainName "The base domain name.";
    acmeEmail = mkOpt types.str config.mine.defaults.web.acmeEmail "Email used for acme.";
  };

  config = mkIf cfg.enable {

    security.acme.certs."${cfg.domainName}".email = "${cfg.acmeEmail}";

    services.nginx = {
      virtualHosts = {
        "${cfg.domainName}" = {
          default = true;
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              root = "/var/www/${cfg.domainName}/";
            };
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/www/${cfg.domainName} 0755 nginx nginx -"
    ];

  };
}