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
      # If there are some fonts not present in nixpkgs
      xdg.dataFile."fonts".source = ./font-files;
      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.droid-sans-mono
        nerd-fonts.symbols-only
      ];
    };
  };
}