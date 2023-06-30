{ inputs,pkgs,username, ... }:

{
  # xserver configuration
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager = {
      defaultSession = "hyprland";
      sessionPackages = [ inputs.hyprland.packages.${pkgs.system}.default ];
      autoLogin = {
        enable = false;
        user = "zaluru";
      };
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager = {
        cinnamon.enable = true;
    };
  };
}
