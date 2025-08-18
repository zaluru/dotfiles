{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.cli-tools.age;

in
{
  options.mine.cli-tools.age = {
    enable = mkEnableOption "age - Modern encryption tool";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = with pkgs; [ age ssh-to-age ];
    };
  };
}