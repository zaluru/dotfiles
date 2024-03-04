{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ polychromatic ];
  hardware.openrazer.enable = true;
  users.users.zaluru.extraGroups = [ "plugdev" ];
}
