{ inputs
, pkgs
, ... }:

{
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    base16Scheme = ./themes/base16-oxocarbon-dark.yml; 
    image = ../wallpapers/Hydrogen_Remixed.png; 
    autoEnable = true;

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };
    };

    targets = {
      gtk.extraCss = ''
        // Remove rounded corners
        window.background { border-radius: 0; }
      '';
    };
  }; 
}

