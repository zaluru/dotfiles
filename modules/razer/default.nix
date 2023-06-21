{ lib, username, hostname, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    polychromatic
  ];
  hardware.openrazer.enable = true;
  users.users.zaluru.extraGroups = [ "plugdev" ];
}

