{ pkgs, ... }:
{
  # If there are some fonts not present in nixpkgs
  xdg.dataFile."fonts".source = ./fonts;
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "DroidSansMono"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];
  fonts.fontconfig.enable = true;
}
