{ pkgs
, ... }:

{
  home.packages = with pkgs; [
    gcc
    nix-prefetch-github
    vscodium-fhs
    devbox
    just
    asdf-vm
  ];
}
