{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.fonts;

in
{
  options.mine.system.fonts = {
    enable = mkEnableOption "Enable Fonts";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "DroidSansMono"
            "NerdFontsSymbolsOnly"
          ];
        })
      ];
    };
  };
}