{ pkgs
,inputs
, xdg-hyprland
, ...
}: {
  home.packages = with pkgs; [
    grim
    slurp
    libnotify
    swww
    kitty
    dunst
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
    wf-recorder
    glib
    vlc
    unzip
    discord
    gparted
    ncmpcpp
    mpd
    wofi
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
    cava
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    git
    swww
  ];
}
