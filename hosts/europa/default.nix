{
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  system.stateVersion = "24.05";

  disko.devices = import ./disk-configuration.nix { inherit lib; };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 2048;
    }
  ];

  boot = {
    supportedFilesystems = [ "btrfs" ];

    loader.grub = {
      enable = true;
      forceInstall = true;
      device = "/dev/sda";
    };
  };

  networking = {
    hostName = "europa";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 ];
    };
  };

  nix = {
    #package = pkgs.nixVersions.nix_2_13;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  users = {
    groups.minecraft = { };

    users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGAve2m9ceVDIY0cechCRIt6Iepcb/9DSSKfqsoUX9fi"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDmI0SQTxupC+ehMYAZVgViMwQgoT/2w8cRr8hFZkgjt"
      ];

      minecraft = {
        group = "minecraft";
        isSystemUser = true;
      };
    };
  };

  virtualisation = {
    oci-containers = {
      backend = "podman";
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
    };

    # this comes with SSH jail by default
    fail2ban.enable = true;
  };
}
