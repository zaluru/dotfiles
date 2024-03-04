{ pkgs, ... }:

let
  terminalApp = "${pkgs.alacritty}/bin/alacritty -e";
in
{
  xdg = {
    desktopEntries = {
      file = {
        name = "File Manager";
        exec = "${pkgs.xfce.thunar}/bin/thunar %u";
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
        exec = "${pkgs.qbittorrent}/bin/qbittorrent %U";
        categories = [ "Application" ];
      };
      video = {
        name = "Video Player";
        exec = "${pkgs.mpv}/bin/mpv %f";
        categories = [ "Application" ];
      };
    };
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
        "x-scheme-handler/lbry" = [ "lbry.desktop" ];
        "inode/directory" = [ "file.desktop" ];
      };
    };
  };
}
