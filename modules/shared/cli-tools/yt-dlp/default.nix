{
  pkgs,
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.yt-dlp;

in
{
  options.mine.cli-tools.yt-dlp = {
    enable = mkEnableOption "Enable yt-dlp,feature-rich command-line audio/video downloader.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yt-dlp
    ];
  };
}
