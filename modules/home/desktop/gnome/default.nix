{ pkgs
, ... }:

{
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-connections
    gnome-console
    gnome-photos
    gnome-text-editor
    gnome-tour
    orca
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gedit # text editor
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-initial-setup
    gnome-terminal
    adwaita-icon-theme
    epiphany
    evince
    file-roller
    geary
    gnome-backgrounds
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-screenshot
    gnome-themes-extra
    gnome-weather
    nautilus
    simple-scan
    sushi
    totem
    yelp
  ]);
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];
}
