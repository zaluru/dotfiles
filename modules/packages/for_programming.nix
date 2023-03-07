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
    
    neovim
    typescript
    rnix-lsp
    # rust
    ];
}
