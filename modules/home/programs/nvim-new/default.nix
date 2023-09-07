{ pkgs
, inputs
, ... }:

let

{
  xdg.configFile."nvim".source = ./config;

  programs.neovim = {
    enable = true;
    plugins = with.pkgs [
      vimPlugins.vim-just
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.rust-tools-nvim

      # telescope
      vimPlugins.plenary-nvim
      vimPlugins.popup-nvim
      vimPlugins.telescope-nvim

      # theme
      vimPlugins.catppuccin-nvim

      # floaterm
      vimPlugins.vim-floaterm

      # extras
      vimPlugins.gitsigns-nvim
      vimPlugins.lualine-nvim
      vimPlugins.nerdcommenter
      vimPlugins.noice-nvim
      vimPlugins.nui-nvim
      vimPlugins.nvim-colorizer-lua
      vimPlugins.nvim-notify
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-ts-rainbow2
      # configuration
      inputs.self.packages.${pkgs.system}.thealtf4stream-nvim
    ];

    extraConfig = ''
      lua << EOF
        require 'TheAltF4Stream'.init()
      EOF
    '';

    extraPackages = with pkgs; [
      # languages
      #jsonnet
      #nodejs
      #python310Full
      #rustc

      # language servers
      gopls
      haskell-language-server
      jsonnet-language-server
      lua-language-server
      nil
      nodePackages."bash-language-server"
      nodePackages."diagnostic-languageserver"
      nodePackages."dockerfile-language-server-nodejs"
      nodePackages."pyright"
      nodePackages."typescript"
      nodePackages."typescript-language-server"
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"
      rust-analyzer
      terraform-ls

      # formatters
      gofumpt
      golines
      nixpkgs-fmt
      python310Packages.black
      rustfmt

      # tools
      #cargo
      #gcc
      #ghc
      #lazydocker
      #yarn
    ];
  };
}
