{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.services.gpg-agent;

in
{
  options.mine.services.gpg-agent = {
    enable = mkEnableOption "Enable gpg-agent and pinentry";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.gpg-agent = {
        enable = true;
      };
    };
  };
}
