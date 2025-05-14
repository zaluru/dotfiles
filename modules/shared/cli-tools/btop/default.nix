{
  pkgs,
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.btop;

in
{
  options.mine.cli-tools.btop = {
    enable = mkEnableOption "Enable btop, a terminal based system monitor.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btop
    ];
  };
}
