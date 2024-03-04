{ inputs, pkgs, ... }:

{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  stylix = {
    base16Scheme = ./themes/base16-oxocarbon-dark.yml;
    image = ../wallpapers/Hydrogen_Remixed.png;
    cursor = {
      name = "phinger-cursors";
      package = pkgs.phinger-cursors;
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    autoEnable = true;
    targets = {
      kde.enable = true;
      gtk.enable = true;
      gtk.extraCss = ''
        // Remove rounded corners
        window.background { border-radius: 0; }
      '';
      alacritty.enable = false;
      fish.enable = false;
      waybar.enable = false;
      hyprland.enable = false;
      zellij.enable = false;
    };
  };
}
