{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ]
    ++ [ (import ./fileSystem.nix) ]
    ++ [ (import ./xserver.nix) ]
    ++ [ (import ./vpn.nix) ]
    ++ [ (import ./../../modules/home/packages/python.nix) ]
    ++ [ (import ./hardware.nix) ];

  boot.initrd.availableKernelModules = [
    # Provided by nixos-generate-config
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"

    # Additional
    "rtsx_usb_sdmmc"
    "ehci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

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
  networking.hostId = "add3b19b"; # For ZFS

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

  # Usefull links about gpu drivers for amd on nixos
  # https://nixos.org/manual/nixos/unstable/index.html#sec-gpu-accel-vulkan
  # https://wiki.nixos.org/wiki/Graphics
  # https://wiki.nixos.org/wiki/AMD_GPU

  # This specifies that the radv driver is the default one used
  # TODO: Check if i need to also add there 32bit vulkan driver path as shown here (i dont see both 64 and 32 bit, but i have them enabled hmm)
  # https://www.reddit.com/r/linux_gaming/comments/h8b7zv/comment/furvsmr/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  #environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  # If i want to use a diffrent one i can run an application with the VK_ICD_FILENAMES pointing to the prefered one

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        #amdvlk # if i want to use this rather than radv for some cases
      ];
      extraPackages32 = with pkgs; [
        #driversi686Linux.amdvlk
      ];
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
