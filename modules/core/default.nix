{ config
, pkgs
, ... }:

{
  imports = [
    ./nix.nix
    ./users.nix
    ./openssh.nix
    ./system.nix
    ./security.nix
    ./networking.nix
  ];
}
