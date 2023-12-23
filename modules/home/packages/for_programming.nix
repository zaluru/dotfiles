{ pkgs
, ... }:

{
  home.packages = with pkgs; [
  nodejs
  nodePackages.nodemon
  yarn
  gcc
  nix-prefetch-github
  vscodium-fhs
  devbox
  just
  asdf-vm
  typescript
  rnix-lsp
  # rust
  ];
}
