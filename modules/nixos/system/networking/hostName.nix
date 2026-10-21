{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.system.networking;

in
{
  options.mine.system.networking.hostName = lib.mkOption {
    description = "Hostname";
    type = lib.types.str;
    default = "localhost";
  };

  config = {
    networking.hostName = cfg.hostName;
  };
}
