{ username, ... }:

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
}
