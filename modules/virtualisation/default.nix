{ config, pkgs, ... }:

{
  # TODO: Broken in 24.11
  #imports = [ ./vagrant.nix ];

  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    podman-compose
    docker-compose
    guestfs-tools
    crun # containers runtime
    freerdp3 # rdp client for vagrant
  ];

  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
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
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
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
    virtualbox.host = {
      enable = true;
      addNetworkInterface = true;
    };
  };
  # TODO learn more about this option
  # This enables rootles podman from what i have found
  #security.unprivilegedUsernsClone = true;
}
