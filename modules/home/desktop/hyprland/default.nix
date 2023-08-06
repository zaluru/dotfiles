{ inputs
, pkgs
, ... }:

{
  imports = 
    [ inputs.hyprland.homeManagerModules.default ] ++
    [(import ../default.nix)] ++
    [(import ../programs/dunst)] ++
    [(import ../programs/waybar)] ++
    [(import ../programs/tofi)];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    nvidiaPatches = true;
    systemdIntegration = true;
  };
  xdg.configFile."hypr".source = ./config;
}
