{ ... }:

# glue all configs together
{
  config.home.stateVersion = "24.05";
  config.home.extraOutputsToInstall = [
    "doc"
    "devdoc"
  ];
  imports = [
    #./desktop
    #./gtk
    ./packages
    ./wallpapers
    ./scripts
    ./programs
    #./editors
    ./stylix
  ];
}
