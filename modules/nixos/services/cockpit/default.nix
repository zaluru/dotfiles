{
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.cockpit;

in
{
  options.mine.services.cockpit = {
    enable = mkEnableOption "Enable Cockpit.";
  };

  config = mkIf cfg.enable {
    services.cockpit.enable = true;
  };
}