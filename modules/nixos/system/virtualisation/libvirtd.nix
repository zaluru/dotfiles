{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.system.virtualisation.libvirtd;

in
{
  options.mine.system.virtualisation.libvirtd = {
    enable = mkEnableOption "libvirtd";
  };

  # TODO: libvirtd in 25.11 dose not have the libvirtd.dbus option
  disabledModules = [
    "virtualisation/libvirtd.nix"
  ];

  imports = [
    "${inputs.unstable}/nixos/modules/virtualisation/libvirtd.nix"
  ];

  config = mkIf cfg.enable {
    users.users.${user.name}.extraGroups = mkIf user.enable [
      "libvirtd"
      "qemu-libvirtd"
    ];

    environment.systemPackages = with pkgs; [
      virt-manager
      libvirt-dbus
    ];

    virtualisation.libvirtd = {
      enable = true;
      dbus.enable = true;
      allowedBridges = [ "br0" ];
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };
}
