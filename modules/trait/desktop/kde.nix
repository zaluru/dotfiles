{ lib
, config
, pkgs
, inputs
, ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt enabled;
  inherit (config.mine) user;
  cfg = config.mine.trait.desktop.kde;

in
{
  options.mine.trait.desktop.kde = {
    enable = mkOpt types.bool false "Enabled trait - desktop.kde";
  };

  config = mkIf cfg.enable {
  };
}