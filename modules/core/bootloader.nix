{ pkgs, lib, ... }:

{
  # bootloader configuration
  boot = {
    tmp.cleanOnBoot = true;
    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "rtsx_usb_sdmmc"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [
      "kvm-intel"
      "vfio-pci"
    ];
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "loglevel=7"
      "quiet"
      "logo.nologo"
      "rootflags=noatime"
      "usbcore.autosuspend=-1"
      "rd.systemd.show_status=auto"
      "rd.udev.log_priority=3"
      "rd.udev.log_level=3"
    ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    # I'm currently not using ZFS, and the latest Xanmod kernel version is not yet supported by OpenZFS
    #supportedFilesystems = [ "ntfs" "zfs" ];
    #zfs.forceImportRoot = false;
    # Changes from default kernel to xanmod
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
    consoleLogLevel = 0;
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      timeout = 1;
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
        theme = null;
        backgroundColor = null;
        splashImage = null;
      };
    };
  };
}
