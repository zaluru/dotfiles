{ inputs
, pkgs
, config
, lib
, self
, ... }:

# glue all configs together
{
  config.home.stateVersion = "23.05";
  config.home.extraOutputsToInstall = ["doc" "devdoc"];
  imports = [
    ./desktop
    ./gtk
    ./packages
    ./wallpapers
    ./scripts
    ./programs
    #./editors
    ./bottom
    ./stylix
  ];
}
