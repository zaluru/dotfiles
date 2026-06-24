{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.vscode;

in
{
  options.mine.apps.vscode = {
    enable = mkEnableOption "vscode";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhs;
      };
    };
  };
}
