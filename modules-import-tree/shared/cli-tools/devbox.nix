{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.devbox;

in
{
  options.mine.cli-tools.devbox = {
    enable = mkEnableOption "Enable devbox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.devbox
    ];
  };
}