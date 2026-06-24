{
  lib,
  config,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
let

  inherit (lib.zaluru) enabled;
  inherit (config.mine) user;

in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ../../overlays/inputs
    ../../modules/nixos/import.nix
    ../../modules/home/import.nix
    (inputs.import-tree ../../modules-import-tree)
  ];

  config = {

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    system.stateVersion = "26.05";

    #hardware.cpu.amd.updateMicrocode = true;
    hardware.cpu.intel.updateMicrocode = true;

    boot.loader.grub.device = "/dev/sda";

    services = {
      cloud-init = {
        enable = true;
        network.enable = true;
        config = ''
          system_info:
            distro: nixos
            network:
              renderers: [ 'networkd' ]
          ssh_pwauth: false
          chpasswd:
            expire: false
          cloud_init_modules:
            - migrator
            - seed_random
            - growpart
            - resizefs
          cloud_config_modules:
            - disk_setup
            - mounts
            - set-passwords
            - ssh
          cloud_final_modules: []
          '';
      };
    };

    mine = {
      user = {
        enable = true;
        home-manager = enabled;
      };

      home-manager = {
        git = enabled;
        ssh-config = enabled;
      };

      system = {
        networking = {
          networkmanager = {
            enable = true;
            hostname = "nixos-cloud";
          };
          firewall = enabled;
        };
        nix = {
          unfree = enabled;
          flakes = enabled;
        };
        security.sudonopass = enabled;
        services = {
          openssh = enabled;
        };
      };
    };

  };
}
