{ lib, config, pkgs, ... }:

{
  hardware.pulseaudio.enable = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;
}
