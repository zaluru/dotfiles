{ pkgs, ... }:
{
  programs.nixvim = {
    colorschemes.oxocarbon.enable = true;
    extraConfigLua = ''
      vim.opt.background = "dark"
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    '';
  };
}
