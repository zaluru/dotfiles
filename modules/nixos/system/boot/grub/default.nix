{ lib, config, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.boot.grub;

in
{
  options.mine.system.boot.grub = {
    enable = mkEnableOption "Enable Grub Bootloader";
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      #theme = null;
      #backgroundColor = null;
      #splashImage = null;
    };
  };
}
