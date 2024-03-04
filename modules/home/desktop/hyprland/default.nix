{ pkgs, inputs, ... }:

let
  autostart-hyprland = pkgs.writeShellScriptBin "autostart-hyprland" (
    builtins.readFile ./autostart-hyprland.sh
  );
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
      variables = [ "--all" ];

      # TODO read more why this might be usefull, left for future reference
      #extraCommands = [
      #  "systemctl --user stop graphical-session.target"
      #  "systemctl --user start hyprland-session.target"
      #];
    };
  };

  home.packages = with pkgs; [ autostart-hyprland ];
}
