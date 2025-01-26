{ pkgs, pkgs-unstable, ... }:

{
  home.packages =
    (with pkgs; [
      keepassxc
      kitty
      dunst
      adw-gtk3
      xfce.thunar
      firefox
      mullvad-browser
      tor-browser-bundle-bin
      tangram
      tofi
      wlogout
      qalculate-gtk
      swaylock-effects
      imv
      libsForQt5.dolphin
      libreoffice
      hyprpicker
      #inputs.davinciresolve.packages.${pkgs.system}.davinci-resolve
      #qbittorrent
      thunderbird
      android-file-transfer
      nebula
      remmina
      #jetbrains.phpstorm
      #jetbrains.datagrip
      #jetbrains.rider
      dbeaver-bin
      tutanota-desktop
      libsForQt5.kdenlive
      blender-hip
      reaper
      shotcut
      gimp
      inkscape
      drawio
      webcord
      #itch
      chatterino2
      discord
      #renoise
      gparted
      vlc
      wf-recorder
      swww
      grim
      slurp
      qrencode
      xdg-ninja
      gpu-viewer
      nvtopPackages.full # gpu monitoring
      davinci-resolve
      heroic
    ])
    ++ (with pkgs-unstable; [ ryujinx ]);
}
