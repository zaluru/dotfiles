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
  cfg = config.mine.apps.bruno;

in
{
  options.mine.apps.bruno = {
    enable = mkOpt types.bool false "Enable Bruno API client IDE.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [
        bruno
      ];
    };
  };
}
