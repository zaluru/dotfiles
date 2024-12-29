{ pkgs, config, ... }:

{
  # xserver configuration
  services.xserver = {
    enable = true;
    #videoDrivers = [ "amd" ];
    displayManager = {
      #defaultSession = "hyprland";
      #sessionPackages = [ inputs.hyprland.packages.${pkgs.system}.default ];
      autoLogin = {
        enable = false;
        user = "zaluru";
      };
    };
  };
}
