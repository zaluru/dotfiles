{
  pkgs,
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.tealdeer;

in
{
  options.mine.cli-tools.tealdeer = {
    enable = mkEnableOption "Enable tealdeer, simplified, example based and community-driven man pages.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tealdeer
    ];
  };
}
