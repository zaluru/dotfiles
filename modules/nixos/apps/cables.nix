{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.cables;

in
{
  options.mine.apps.cables = {
    enable = mkEnableOption "Cables";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.unstable.cables
    ];
  };
}
