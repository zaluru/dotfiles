{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports =
    [ (import ./fileSystem.nix) ]
    ++ [ (import ./xserver.nix) ]
    ++ [ (import ./vpn.nix) ]
    ++ [ (import ./../../modules/home/packages/python.nix) ]
    ++ [ (import ./hardware.nix) ];

  # basic configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "24.11";

  # Pipewire
  # TODO there is some crackling noise in discord, propably related to those:
  # https://www.reddit.com/r/linux_gaming/comments/vg8gl2/comment/id4liim/
  # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2476
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # networking
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  # programs
  programs.dconf.enable = true;

  # services
  services.getty.autologinUser = "zaluru";
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;
  services.flatpak.enable = true;
  # Firmware updates
  services.fwupd.enable = true;
  services.cockpit.enable = true;

  security.pam.services.swaylock = { };
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
    memoryPercent = 50;
    algorithm = "zstd";
  };

  hardware = {
    # TODO: Removed in 24.11
    #opengl = {
      #enable = true;
      #driSupport = true;
      #driSupport32Bit = true;
    #};
  };
}
