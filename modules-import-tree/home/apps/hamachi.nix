{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkIf mkForce types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.hamachi;

in
{
  options.mine.apps.hamachi = {
    enable = mkOpt types.bool false "Install hamachi vpn";
    startOnBoot = mkOpt types.bool true ''
      Whether logmein-hamachi should start at boot.
      Defaults to true.
    '';
  };

  config = mkIf cfg.enable {
    services.logmein-hamachi.enable = true;
    systemd.services."logmein-hamachi" = mkIf (!cfg.startOnBoot) {
      wantedBy = mkForce [ ];
    };
    programs.haguichi.enable = true;
  };
}