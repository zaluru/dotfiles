{ lib, pkgs, ... }:

{
  imports =
    [ (import ./fileSystem.nix) ]
    ++ [ (import ./vpn.nix) ]
    ++ [ (import ./../../modules/home/packages/python.nix) ];

  # basic configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "24.05";

  # networking
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  # programs
  programs.dconf.enable = true;

  # services
  services.gvfs.enable = true;
  services.dbus.enable = true;
  # Firmware updates
  services.fwupd.enable = true;
  services.cockpit.enable = true;

  environment.systemPackages = with pkgs; [
    git
    libvirt
    pciutils
    virt-manager
    qemu
    kmod
    quickemu
    spice-gtk
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
  };
}
