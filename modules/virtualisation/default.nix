{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    podman-compose
    docker-compose
  ];
  users.users.zaluru = {
    extraGroups = [
      "lxd"
      "docker"
      "podman"
      "vboxusers"
      "libvirtd"
    ];
  };
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    docker = {
      enable = true;
    };
    podman = {
      enable = true;
      #dockerSocket.enable = true;
      #dockerCompat = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    lxd = {
      enable = true;
      recommendedSysctlSettings = true;
    };
  };
  # TODO learn more about this option
  # This enables rootles podman from what i have found
  #security.unprivilegedUsernsClone = true;
}
