{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.nextdns;

in
{
  options.mine.services.nextdns = {
    enable = mkEnableOption "Enable NextDNS.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nextdns ];

    services.nextdns = {
      enable = true;
    };

    systemd.services.nextdns-activate = {
      script = ''
        /run/current-system/sw/bin/nextdns activate
      '';
      after = [ "nextdns.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}