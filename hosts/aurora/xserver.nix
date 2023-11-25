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
      #sessionPackages = [ inputs.hyprland.packages.${pkgs.system}.default ];
      autoLogin = {
        enable = false;
        user = "zaluru";
      };
    };
  };
  hardware.nvidia.prime = {
    # You can find the gpu BusId with:
    # nix-shell -p pciutils --run "lspci | grep -E 'VGA|3D'"
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:4:0:0";
  };
}
