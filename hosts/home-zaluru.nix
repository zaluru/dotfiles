{ username
, config
, lib
, ... }:

{
  imports =
    [ (import ./../modules/home)];
  home.username = "${username}";
  home.homeDirectory = lib.mkDefault "/home/zaluru";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.git.userName = "${username}";
  programs.git.userEmail = "zaluru@tutamail.com";

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
