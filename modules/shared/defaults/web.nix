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
  cfg = config.mine.defaults.web;

in
{
  options.mine.defaults.web = {
    domainName = mkOpt types.str "changeme.local" "Default domain name used by all web services";
    acme = {
      acceptTerms = mkOpt types.bool false "Acme terms acceptance";
      email = mkOpt types.str "acme@changeme.local" "Default acme email used by all web services";
    };
  };

  config = mkIf cfg.acme.acceptTerms {
    security.acme = {
      acceptTerms = true;
      defaults.email = "${cfg.acme.email}";
    };
  };
}
