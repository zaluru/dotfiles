{
  config,
  pkgs,
  ...
}: {
  users.users.root.initialPassword = "zaq1@WSX";
  programs.fish.enable = true;
  users.users.zaluru = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "podman"
      "systemd-journal"
      "vboxusers"
      "libvirtd"
      "audio"
      "plugdev"
      "wireshark"
      "video"
      "input"
      "lp"
      "networkmanager"
      "power"
      "nix"
    ];
    uid = 1000;
    shell = pkgs.fish;
    initialPassword = "zaq1@WSX";
    #openssh.authorizedKeys.keys = [""];
  };
}
