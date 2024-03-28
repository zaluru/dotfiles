{ pkgs, ... }:

{
  home.packages = with pkgs; [
    skim
    ripgrep
    bat
    libnotify
    tealdeer
    ranger
    ueberzug
    bottom
    wl-clipboard
    pavucontrol
    wget
    glib
    unzip
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
    scrcpy
    #mutt-wizard
    lsof
  ];
}
