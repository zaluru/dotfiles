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
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;

  # For my razer mouse
  hardware.openrazer.enable = true;
}
