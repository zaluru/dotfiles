{ pkgs, ... }:
{
  imports = [ ];

  config = {
    system.stateVersion = "25.11";

    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    #hardware.cpu.amd.updateMicrocode = true;
    hardware.cpu.intel.updateMicrocode = true;

    systemd.network.enable = true;

    networking = {
      useDHCP = true;
      useNetworkd = true;
      hostName = "nixos";
    };

    services = {
      qemuGuest.enable = true;
      openssh.enable = true;
      cloud-init = {
        enable = true;
        network.enable = true;
        config = ''
          system_info:
            distro: nixos
            network:
              renderers: [ 'networkd' ]
            default_user:
              name: zaluru
          users:
              - default
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

    users.users.root.initialPassword = "zaq1@WSX";
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrGryK6mx13Qw16qf+g1pIMpdjYnO98aC0HfVJWBg1M root@nebula"
    ];

    environment.systemPackages = with pkgs; [
      neovim
      git
    ];
  };
}
