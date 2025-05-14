{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.home-manager.ssh-config;
in
{
  options.mine.home-manager.ssh-config = {
    enable = mkEnableOption "SSH config";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.ssh = {
        enable = true;
        forwardAgent = true;
        addKeysToAgent = "yes";
      };
    };
  };
}
