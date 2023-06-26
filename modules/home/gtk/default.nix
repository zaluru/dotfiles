{ pkgs, ... }:

{
  imports = 
    [(import ./fonts)] ++ 
    [(import ./themes)];
  gtk = {
    enable = true;
    font.name = "Operator Mono";
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
#    theme = {
#      # TODO find how to properly set themes for gtk3 and gtk4
#      name = "adw-gtk3-dark";
#      package = pkgs.adw-gtk3; 
#    };
  };
}
