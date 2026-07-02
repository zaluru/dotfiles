{ lib, config, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.boot.plymouth;

in
{
  options.mine.system.boot.plymouth = {
    enable = mkEnableOption "Enable Plymouth boot splash screen.";
  };

  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
    };
  };
}
