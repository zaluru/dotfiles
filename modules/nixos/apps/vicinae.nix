{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.vicinae;

in
{
  options.mine.apps.vicinae = {
    enable = mkEnableOption "Enable vicinae - high performance launcher.";

  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.vicinae = {
        enable = true;
        systemd = {
          enable = true;
          autoStart = true;
        };
      };
    };
  };
}
