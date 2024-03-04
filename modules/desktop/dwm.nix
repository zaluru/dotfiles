{ pkgs, username, ... }:
{
  services.xserver.windowManager.dwm = {
    enable = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: {
        src = /home/${username}/dev/x11/dwm;
      });
      dwmblocks = prev.dwmblocks.overrideAttrs (old: {
        src = /home/${username}/dev/x11/dwmblocks;
      });
      dmenu = prev.dmenu.overrideAttrs (old: {
        src = /home/${username}/dev/x11/dmenu;
      });
    })
  ];
  environment.systemPackages = with pkgs; [
    dwmblocks
    dmenu
    xwallpaper
  ];
}
