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
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };
  # TODO learn more about this option
  # This enables rootles podman from what i have found
  #security.unprivilegedUsernsClone = true;
}
