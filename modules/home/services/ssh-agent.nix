{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.services.ssh-agent;

in
{
  options.mine.services.ssh-agent = {
    enable = mkEnableOption "Enable ssh-agent";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.ssh-agent.enable = true;
    };
  };
}
