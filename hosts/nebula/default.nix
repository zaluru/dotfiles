{ lib, username, hostname, pkgs, inputs, ... }:

{
  imports =
    [ (import ./plymouth.nix) ] ++
    [ (import ./fileSystem.nix) ] ++
    [ (import ./xserver.nix) ] ++
    [ (import ./vpn.nix) ] ++
    [ (import ./containers.nix) ] ++
    [ (import ./../../modules/packages/python.nix ) ] ++
    [ (import ./hardware.nix) ];

  # basic configuration
  time.timeZone = "Europe/Warsaw";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.05";

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
  networking.hostName = "aurora";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;


  # programs
  programs.dconf.enable = true;

  # xdg-desktop-portals
  # this should be managed by hyprland desktop portals, but i don't know how to set it up on nix
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland ];
    #gtkUsePortal = true;
  };


  # security
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = ["zaluru"];
    keepEnv = true;
    persist = true;
  }];



  # services
  services.getty.autologinUser = "zaluru";
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;
  services.flatpak.enable = true;
  # Firmware updates
  services.fwupd.enable = true;
  services.cockpit.enable = true;

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # nix setting
  nix.settings.allowed-users = ["zaluru"];
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";
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
  
  # Environment variables for nvidia
  environment.sessionVariables = rec {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "DroidSansMono" ]; })
  ];
}
