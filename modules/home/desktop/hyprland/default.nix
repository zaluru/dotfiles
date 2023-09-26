{ inputs
, pkgs
, ... }:

{
  imports = 
    [(import ../default.nix)] ++
    [(import ../programs/dunst)] ++
    [(import ../programs/waybar)] ++
    [(import ../programs/tofi)];

  wayland.windowManager.hyprland = {
    #enable = true;
    xwayland = {
      enable = true;
    };
    enableNvidiaPatches = true;
    systemdIntegration = true;
  };
  xdg.configFile."hypr".source = ./config;
}
