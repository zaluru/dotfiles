{
  username,
  config,
  pkgs,
  ...
}:

{
  imports = [ (import ./../modules/home) ];
  home.username = "zaluru";
  home.homeDirectory = "/home/zaluru";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

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
