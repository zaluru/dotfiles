{ pkgs, ... }:

{
  # bootloader configuration
  boot = {
    cleanTmpDir = true;
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" "vfio-pci" ];
    kernelParams = [ "intel_iommu=on" "iommu=pt" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    #kernelPackages = ;
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
