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
    godot_4
    
    neovim
    typescript
    rnix-lsp
    # rust
    ];
}
