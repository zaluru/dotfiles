{ pkgs, ... }:
{
  programs.nixvim = {
    colorschemes.oxocarbon.enable = true;
    #extraPlugins = [ pkgs.vimPlugins.oxocarbon-nvim ];
    #extraConfigLua = ''
    #  require("oxocarbon").setup({
    #      transparent_mode = true,
    #  })
    #  vim.cmd("colorscheme oxocarbon")
    #'';
    #extraPlugins = [ pkgs.vimPlugins.gruvbox-nvim ];
    #extraConfigLua = ''
    #  require("gruvbox").setup({
    #      transparent_mode = true,
    #  })
    #  vim.cmd("colorscheme gruvbox")
    #'';
  };
}
