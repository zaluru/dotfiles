{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=nixos-root" ];
    };

  boot.initrd.luks.devices."ssd".device = "/dev/disk/by-uuid/125357d9-611c-4c9e-bac4-45ba531158a2";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=nixos-home" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=nixos-var" ];
    };

  fileSystems."/home/zaluru/books" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=books" ];
    };

  fileSystems."/home/zaluru/dev" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=development" ];
    };

  fileSystems."/home/zaluru/documents" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=documents" ];
    };

  fileSystems."/home/zaluru/downloads" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=downloads" ];
    };

  fileSystems."/home/zaluru/games" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=games" ];
    };

  fileSystems."/home/zaluru/.local/share/keepassxc" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=keepassxc" ];
    };

  fileSystems."/home/zaluru/music" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=music" ];
    };

  fileSystems."/home/zaluru/pictures" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=pictures" ];
    };

  fileSystems."/home/zaluru/.ssh" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=ssh" ];
    };

  fileSystems."/home/zaluru/torrents" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=torrents" ];
    };

  fileSystems."/home/zaluru/videos" =
    { device = "/dev/disk/by-uuid/0a1d8011-b515-4cec-89e2-05eb50ea6073";
      fsType = "btrfs";
      options = [ "subvol=videos" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7F9D-D35B";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
