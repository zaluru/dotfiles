{ pkgs
, ... }:

{
  home.packages = with pkgs; [
    skim
    ripgrep
    bat
    grim
    slurp
    libnotify
    swww
    tealdeer
    rnix-lsp
    ranger
    ueberzug
    bottom
    wl-clipboard
    pavucontrol
    wget
    wf-recorder
    glib
    vlc
    mpv
    unzip
    gparted
    tty-clock
    playerctl
    bleachbit
    cmatrix
    cava
    git
    croc
    termscp
    yt-dlp
    flyctl
    distrobox
    fzf
    glxinfo
    dig # Tools for diagnosing DNS-related issuse 
    rsync
    inetutils
  ];
}
