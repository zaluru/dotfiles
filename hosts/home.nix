{ username, config, pkgs, ... }:

{
  imports =
    # Import all personal modules
    # TODO do it in one line liek hlissner https://github.com/hlissner/dotfiles/blob/master/default.nix
    [ (import ./../modules/desktop) ] ++
    [ (import ./../modules/gtk) ] ++
    [ (import ./../modules/packages) ] ++
    [ (import ./../modules/wallpapers) ] ++
    [ (import ./../modules/scripts) ] ++
    #[ (import ./../modules/editors) ] ++
    [ (import ./../modules/programs) ];
  home.username = "zaluru";
  home.homeDirectory = "/home/zaluru";
  home.stateVersion = "22.11";
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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
        gtk-theme = "adw-gtk3-dark";
        color-scheme = "prefer-dark";
      };
#    "org/gnome/desktop/wm/preferences" = {
#        button-layout = '';
#      };
  };

}
