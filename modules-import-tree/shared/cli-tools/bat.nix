{
  pkgs,
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.bat;

in
{
  options.mine.cli-tools.bat = {
    enable = mkEnableOption "Enable bat, `cat` clone with syntax highlighting.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bat
    ];
  };
}
