{ pkgs
, inputs
, ... }:

let 
  autostart-hyprland = pkgs.writeShellScriptBin "autostart-hyprland" (builtins.readFile ./autostart-hyprland.sh);
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./settings.nix
    ./rules.nix
    ./binds.nix
    ../default.nix
    ../programs/default.nix
    ../programs/dunst
    ../programs/waybar
    ../programs/defaultApps.nix
    ../programs/tofi
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    systemd = {
      variables = ["--all"];
    };
  };

  home.packages = with pkgs; [
    autostart-hyprland
  ];
}
