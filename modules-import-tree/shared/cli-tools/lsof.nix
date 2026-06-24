{
  pkgs,
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.lsof;

in
{
  options.mine.cli-tools.lsof = {
    enable = mkEnableOption "Enable lsof, lists open files and the corresponding processes.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lsof
    ];
  };
}
