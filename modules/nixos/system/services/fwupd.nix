{
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.services.fwupd;

in
{
  options.mine.system.services.fwupd = {
    enable = mkEnableOption "Enable fwupd, a DBus service that allows applications to update firmware.";
  };

  config = mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
