{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.podman-compose];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
