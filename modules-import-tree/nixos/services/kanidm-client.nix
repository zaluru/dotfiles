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
  cfg = config.mine.services.kanidm-client;

in
{
  options.mine.services.kanidm-client = {
    enable = mkOpt types.bool false "Kanidm client - simple identity management platform.";
    domainIdm = mkOpt types.str "idm.i.zaluru.com" "Domain on which the kanidm will be available";
  };

  config = mkIf cfg.enable {
    services.kanidm = {
      package = lib.mkForce pkgs.kanidmWithSecretProvisioning_1_10;
      client = {
        enable = true;
        settings.uri = "https://${cfg.domainIdm}";
      };
    };

    environment.systemPackages = [ pkgs.kanidmWithSecretProvisioning_1_10 ];
  };
}
