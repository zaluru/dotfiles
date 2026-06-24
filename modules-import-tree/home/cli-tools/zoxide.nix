{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.home-manager.zoxide;

in
{
  options.mine.home-manager.zoxide = {
    enable = mkEnableOption "zoxide - smarter cd";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        #options = [
        #  "--cmd cd"
        #];
        # TODO: Maybe add this fish plugin - https://github.com/icezyclon/zoxide.fish 
      };
    };
  };
}