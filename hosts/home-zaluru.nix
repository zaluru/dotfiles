{ username
, config
, pkgs
, ... }:

{
  imports =
    [ (import ./../modules/home)];
  home.username = "zaluru";
  home.homeDirectory = "/home/zaluru";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.git.userName = "zaluru";
  programs.git.userEmail = "zaluru@tutamail.com";

  # Cursor theme
  home.pointerCursor = {
    package = pkgs.phinger-cursors;
    name = "phinger-cursors";
  };

  # xdg-user-dirs
  xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
      templates = "${config.xdg.userDirs.documents}/templates";
      publicShare = "${config.xdg.userDirs.documents}/public";
    };

#  dconf.settings = {
#   "org/gnome/desktop/interface" = {
#       color-scheme = "prefer-dark";
#     };
#    "org/gnome/desktop/wm/preferences" = {
#        button-layout = '';
#      };
#  };

}
