{ lib, config, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.desktop.plasma-login;

in
{
  options.mine.desktop.plasma-login = {
    enable = mkOpt types.bool false "Enable plasma login display manager";
  };

  config = mkIf cfg.enable {
    services.displayManager.plasma-login-manager.enable = true;
  };
}