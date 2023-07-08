{ config
, pkgs
, ... }:

{
  imports = 
    [(import ./fonts)] ++ 
    [(import ./themes)];
  gtk = {
    enable = true;
    font.name = "Operator Mono";
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
#    theme = {
#      # TODO find how to properly set themes for gtk3 and gtk4
#      name = "adw-gtk3-dark";
#      package = pkgs.adw-gtk3; 
#    };
  };

  # credits: bruhvko
  # catppuccin theme for qt-apps
  home.packages = with pkgs; [libsForQt5.qtstyleplugin-kvantum];

  xdg.configFile."Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.kvconfig";
    sha256 = "1f8xicnc5696g0a7wak749hf85ynfq16jyf4jjg4dad56y4csm6s";
  };
  xdg.configFile."Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.svg";
    sha256 = "0vys09k1jj8hv4ra4qvnrhwxhn48c2gxbxmagb3dyg7kywh49wvg";
  };
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=catppuccin

    [Applications]
    catppuccin=Dolphin, dolphin, Nextcloud, nextcloud, qt5ct, org.kde.dolphin, org.kde.kalendar, kalendar, Kalendar, qbittorrent, org.qbittorrent.qBittorrent, keepassxc
  '';
}
