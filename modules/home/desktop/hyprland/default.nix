{ pkgs
, ... }:

let 
  autostart-hyprland = pkgs.writeShellScriptBin "autostart-hyprland" (builtins.readFile ./autostart-hyprland.sh);
in
{
  imports = 
    [(import ./settings.nix)] ++
    [(import ./rules.nix)] ++
    [(import ./binds.nix)] ++
    [(import ../default.nix)] ++
    [(import ../programs/default.nix)] ++
    [(import ../programs/dunst)] ++
    [(import ../programs/waybar)] ++
    [(import ../programs/defaultApps.nix)] ++
    [(import ../programs/tofi)];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    enableNvidiaPatches = true;
    systemd = {
      variables = ["--all"];
    };
  };

  home.packages = with pkgs; [
    autostart-hyprland
  ];
}
