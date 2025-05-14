{
  pkgs,
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli-tools.croc;

in
{
  options.mine.cli-tools.croc = {
    enable = mkEnableOption "Enable croc, send and receive files easily and securely over any network.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      croc
    ];
  };
}
