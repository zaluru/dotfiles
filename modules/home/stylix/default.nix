{ inputs
, pkgs
, ... }:

{
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    image = ../wallpapers/Hydrogen_Remixed.png; 
    autoEnable = false;
  }; 
}

