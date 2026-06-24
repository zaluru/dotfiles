{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.cli-tools.git;

in
{
  options.mine.cli-tools.git = {
    enable = mkEnableOption "Git configs";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      gh
    ];
  };
}
