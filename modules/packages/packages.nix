{ pkgs
,inputs
, xdg-hyprland
, ...
}: {
  home.packages = with pkgs; [
    keepassxc
    grim
    slurp
    libnotify
    swww
    kitty
    dunst
    tealdeer
    rnix-lsp
    ranger
    ueberzug
    pamixer
    xfce.thunar
    wl-clipboard
    pavucontrol
    wget
    firefox
    ungoogled-chromium
    tangram
    authenticator
    wf-recorder
    glib
    vlc
    unzip
    discord
    gparted
    ncmpcpp
    mpd
    tofi
    wlogout
    tty-clock
    playerctl
    qalculate-gtk
    swaylock-effects
    bleachbit
    imv
    libsForQt5.dolphin
    cmatrix
    shotcut
    #libreoffice
    gimp
    inkscape
    cava
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    git
    swww
  ];
}
