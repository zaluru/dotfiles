{ config, lib, pkgs, inputs, ... }:

{
  xdg.configFile."ghostty/config".text = ''
  theme = Oxocarbon
  window-decoration = false
  '';

  home.packages = [ inputs.ghostty.packages.${pkgs.system}.ghostty ];
}
