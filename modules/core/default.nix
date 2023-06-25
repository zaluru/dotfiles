{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./openssh.nix
    ./system.nix
    ./networking.nix
  ];
}
