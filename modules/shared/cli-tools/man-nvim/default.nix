{
  pkgs,
  lib,
  config,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.man-nvim;

in
{
  options.mine.cli-tools.man-nvim = {
    enable = mkEnableOption "Make man use nvim as its pager.";
  };

# TODO: for some reason the original author uses the nix fish and zsh and not home manager one, so i would have to look why and if i should also move this to not use home manager
  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.zsh.initExtra = ''
        man() {
          env MANPAGER="nvim +Man!" MANWIDTH="999" command man "$@"
        }
      '';     
      programs.fish.enable = true;
      programs.fish.functions.man = ''
        MANPAGER="nvim +Man!" MANWIDTH="999" command man $argv
      '';
    };
  };
}
