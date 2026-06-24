{ lib, config, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.system.nix.nh;

in
{
  options.mine.system.nix.nh = {
    enable = mkOpt types.bool false "nh - Nix cli helper";
  };

  config = mkIf cfg.enable {
    programs = {
      nh = {
        enable = true;
        flake = "/home/zaluru/dev/dotfiles";
        #TODO: make this an option so i can choose between the nix gc and nh clean
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 5";
        };
      };
    };
  };
}