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
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9ExEl6WqtCI4yCqbSAhAGmzvVp/nYADbgy/Qi4AKQy sioodmy@anthe"];
  };
}
