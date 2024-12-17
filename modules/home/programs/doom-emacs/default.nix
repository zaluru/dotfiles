{
  pkgs,
  ... 
}:

{
  home.packages = with pkgs; [
    emacs
    ripgrep
    fd
  ];
  services.emacs.enable = true;
  xdg.configFile."doom" = {
    source = ./config;
    recursive = true;
  };
}
