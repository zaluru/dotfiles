{ lib, pkgs, config, ... }:

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

#  environment.sessionVariables = {
#      LIBVA_DRIVER_NAME = "nvidia";
#      XDG_SESSION_TYPE = "wayland";
#      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
#      GBM_BACKEND = "nvidia-drm";
#      WLR_NO_HARDWARE_CURSORS = "1";
#      # WLR_RENDERER = "vulkan";
#      # GTK_USE_PORTAL = "1";
#      # NIXOS_XDG_OPEN_USE_PORTAL = "1";
#      NIXOS_OZONE_WL = "1";
#      XWAYLAND_NO_GLAMOR = "1";
#  };

  hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      # Most wayland compositors need this
      # nvidia.modesetting.enable = true;
      # nvidia.open = false;
  };

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
