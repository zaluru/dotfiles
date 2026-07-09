{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkIf types mkOption;
  inherit (lib.zaluru) mkOpt;
  cfg = config.mine.defaults.web;

in
{
  options.mine.defaults.web = {
    domainName = mkOpt types.str "changeme.local" "Default domain name used by all web services";
    acme = {
      acceptTerms = mkOpt types.bool false "Acme terms acceptance";
      email = mkOpt types.str "acme@changeme.local" "Default acme email used by all web services";
    };
    server = mkOption {
      default = null;
      description = "Choose the default web server: 'caddy' or 'nginx'";
      type = types.enum [ "caddy" "nginx" ];
    };
  };

  config = mkIf cfg.acme.acceptTerms {
    security.acme = {
      acceptTerms = true;
      defaults.email = "${cfg.acme.email}";
    };
  };
}
