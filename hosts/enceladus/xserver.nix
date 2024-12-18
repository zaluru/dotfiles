{ ... }:

{
  # xserver configuration
  services.xserver = {
    enable = true;
    #videoDrivers = [
    #  "modesetting"
    #];
    displayManager = {
      defaultSession = "hyprland";
      #sessionPackages = [ inputs.hyprland.packages.${pkgs.system}.default ];
      autoLogin = {
        enable = false;
        user = "zaluru";
      };
    };
  };
}
