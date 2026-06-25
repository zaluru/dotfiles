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

  mkAssoc = desktop: types: lib.genAttrs types (_: [ desktop ]);

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
          defaultApplications = lib.mkMerge [
            (mkAssoc "firefox.desktop" [
              "text/html"
              "x-scheme-handler/http"
              "x-scheme-handler/https"
              "x-scheme-handler/about"
              "x-scheme-handler/unknown"
            ])
            (mkAssoc "text.desktop" [
              "text/x-shellscript"
              "text/plain"
            ])
            (mkAssoc "img.desktop" [
              "image/png"
              "image/jpeg"
              "image/gif"
              "image/webp"
            ])
            (mkAssoc "video.desktop" [
              "video/x-matroska"
              "video/mp4"
              "video/webm"
            ])
            (mkAssoc "pdf.desktop" [
              "application/postscript"
              "application/pdf"
            ])
            (mkAssoc "torrent.desktop" [
              "x-scheme-handler/magnet"
              "application/x-bittorrent"
            ])
            (mkAssoc "file.desktop" [
              "inode/directory"
            ])
            (mkAssoc "mail.desktop" [
              "x-scheme-handler/mailto"
            ])
            (mkAssoc "javaws.desktop" [
              # From adoptopenjdk-icedtea-web
              "application/x-java-jnlp-file"
            ])
          ];
        };
      };
    };
  };
}
