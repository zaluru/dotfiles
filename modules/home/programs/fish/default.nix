{ hostname
, ... }:

{
  programs.fish = {
    enable = true;
    # loginShellInit = ''
    #   set TTY1 (tty)
    #   [ "$TTY1" = "/dev/tty1" ] && exec dbus-run-session Hyprland
    # '';
    shellAliases = {
      rebuild = "doas nixos-rebuild switch --flake $HOME/.config/nixos/.#nixos";
      cleanup = "nix-collect-garbage && nix-collect-garbage -d && doas nix-collect-garbage && doas nix-collect-garbage -d && doas rm /nix/var/nix/gcroots/auto/*";
      n = "clear && neofetch";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      record = "wf-recorder -f $HOME/Videos/$(date +'%Y%m%d%H%M%S_1.mp4')";
      ls = "exa -la -s type";
    };
    functions = {
      # Disables the default greeting on new interactive shell
      fish_greeting = "";
    };
  };
}
