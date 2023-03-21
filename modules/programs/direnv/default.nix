{...} : {
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  xdg.configFile."direnv".source = ./config;
}
