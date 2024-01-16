{ ... }:

{
  imports = 
    [(import ../default.nix)] ++
    [(import ../programs/default.nix)]
    [(import ../programs/dunst)] ++
    [(import ../programs/waybar)] ++
    [(import ../programs/defaultApps.nix)] ++
    [(import ../programs/tofi)];

  wayland.windowManager.hyprland = {
    #enable = true;
    xwayland = {
      enable = true;
    };
    enableNvidiaPatches = true;
    systemd.enable = true;
  };
  xdg.configFile."hypr".source = ./config;
}
