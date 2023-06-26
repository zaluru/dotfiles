{
    pkgs,
    ...
} : {
    home.packages = with pkgs; [
    nodejs
    nodePackages.nodemon
    yarn
    gcc
    nix-prefetch-github
    vscodium-fhs
    devbox
    just

    # Game dev
    godot_4
    trenchbroom

    neovim
    typescript
    rnix-lsp
    # rust
    ];
}
