{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    keepassxc
    kitty
    dunst
    adw-gtk3
    xfce.thunar
    firefox
    mullvad-browser
    tor-browser-bundle-bin
    ungoogled-chromium
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
    qbittorrent
    thunderbird
    android-file-transfer
    nebula
    remmina
    jetbrains.phpstorm
    jetbrains.datagrip
    jetbrains.rider
    dbeaver
    tutanota-desktop
    libsForQt5.kdenlive
    blender
    reaper
    shotcut
    gimp
    inkscape
    drawio
    webcord
    itch
  ];
}
