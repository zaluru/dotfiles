{ lib, config, pkgs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.davinci-resolve;

in
{
  options.mine.apps.davinci-resolve = {
    enable = mkOpt types.bool false "Enable davinci resolve - video editing software.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = [ pkgs.davinci-resolve-pkgs.davinci-resolve ];
    };
  };
}