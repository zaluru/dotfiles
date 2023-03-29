{ lib, config, pkgs, ... }:

{
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;
  #hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  #hardware.opengl.extraPackages = with pkgs; [
  #  amdvlk
  #];

  # For my razer mouse
  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "zaluru" ];
}
