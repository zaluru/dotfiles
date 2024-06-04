{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  xdg.configFile."direnv/direnvrc".source = ./config/direnvrc;
}
