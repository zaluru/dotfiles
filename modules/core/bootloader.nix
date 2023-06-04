{ pkgs, ... }:

{
  # bootloader configuration
  boot.cleanTmpDir = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "vfio-pci" ];
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "ntfs" ];
  #boot.kernelPackages = ;
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
}
