{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.losless-cut;

in
{
  options.mine.apps.losless-cut = {
    enable = mkOpt types.bool false "Enable losless-cut - lossless video/audio editing";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ losslesscut-bin ];
    };
  };
}
