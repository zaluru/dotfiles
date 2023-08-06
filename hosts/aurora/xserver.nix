{ inputs
, pkgs
, username
, ... }:

{
  # xserver configuration
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" "nvidia" ];
    displayManager = {
      defaultSession = "hyprland";
      sessionPackages = [ inputs.hyprland.packages.${pkgs.system}.default ];
      autoLogin = {
        enable = false;
        user = "zaluru";
      };
    };
    desktopManager = {
        cinnamon.enable = true;
    };
  };
  hardware.nvidia.prime = {
    # You can find the gpu BusId with:
    # nix-shell -p pciutils --run "lspci | grep -E 'VGA|3D'"
    intelBusId = "0@0:2:0";
    nvidiaBusId = "4@0:0:0";
  };
}
