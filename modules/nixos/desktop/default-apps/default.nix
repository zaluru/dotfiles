{
  lib,
  config,
  pkgs,
  ...
}:
let

  terminalApp = "${pkgs.alacritty}/bin/alacritty -e";
  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.default-apps;

in
{
  options.mine.desktop.default-apps = {
    enable = mkEnableOption "Setup mimeapps list";
  };
  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      xdg = {
        desktopEntries = {
          file = {
            name = "File Manager";
            exec = "${pkgs.kdePackages.dolphin}/bin/dolphin %u";
            categories = [ "Application" ];
          };
          img = {
            name = "Image Viewer";
            exec = "${pkgs.imv}/bin/imv %f";
            categories = [ "Application" ];
          };
          mail = {
            name = "Mail Client";
            exec = "${pkgs.firefox}/bin/thunderbird %u";
            categories = [ "Application" ];
          };
          pdf = {
            name = "PDF reader";
            exec = "${pkgs.zathura}/bin/zathura %u";
            categories = [ "Application" ];
          };
          text = {
            name = "Text Editor";
            exec = "${terminalApp} ${pkgs.neovim}/bin/nvim %u";
            categories = [ "Application" ];
          };
          torrent = {
            name = "Torrent";
            #exec = "${pkgs.qbittorrent}/bin/qbittorrent %U";
            exec = "/bin/qbittorrent %U";
            categories = [ "Application" ];
          };
          video = {
            name = "Video Player";
            exec = "${pkgs.mpv}/bin/mpv %f";
            categories = [ "Application" ];
          };
        };
        configFile."mimeapps.list".force = true; # Often this file gets overwritten by another program and then home manager gets stuck as by default it will not overwrite an existing file
        mimeApps = {
          enable = true;
          defaultApplications = {
            "text/x-shellscript" = [ "text.desktop" ];
            "x-scheme-handler/magnet" = [ "torrent.desktop" ];
            "application/x-bittorrent" = [ "torrent.desktop" ];
            "x-scheme-handler/mailto" = [ "mail.desktop" ];
            "text/plain" = [ "text.desktop" ];
            "application/postscript" = [ "pdf.desktop" ];
            "application/pdf" = [ "pdf.desktop" ];
            "image/png" = [ "img.desktop" ];
            "image/jpeg" = [ "img.desktop" ];
            "image/gif" = [ "img.desktop" ];
            "video/x-matroska" = [ "video.desktop" ];
            "video/mp4" = [ "video.desktop" ];
            "inode/directory" = [ "file.desktop" ];
            #"x-scheme-handler/http" = [ "web.desktop" ];
            #"x-scheme-handler/https=" = [ "web.desktop" ];
          };
        };
      };
    };
  };
}
