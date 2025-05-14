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
  cfg = config.mine.apps.remmina;

in
{
  options.mine.apps.remmina = {
    enable = mkOpt types.bool false "Enable remmina, RDP client";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.remmina.enable = true;
    };
  };
}
