{ inputs
, pkgs
, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
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
