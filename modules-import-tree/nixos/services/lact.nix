{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.lact;

in
{
  options.mine.services.lact = {
    enable = mkEnableOption "Enable Lact - GPU controll and monitoring application.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lact
    ];

    systemd.services.lact = {
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
      enable = true;
    };
  };
}