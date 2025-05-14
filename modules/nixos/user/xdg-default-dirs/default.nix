{
  lib,
  config,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.user.xdg-default-dirs;

in
{
  options.mine.user.xdg-default-dirs = {
    enable = mkEnableOption "Enable ";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      xdg = {
        userDirs = {
          enable = true;
          createDirectories = true;
          documents = "${user.homeDir}/documents";
          download = "${user.homeDir}/downloads";
          music = "${user.homeDir}/music";
          pictures = "${user.homeDir}/pictures";
          videos = "${user.homeDir}/videos";
          # I don't use those
          desktop = "${user.homeDir}/.local/share/.userDirs/desktop";
          templates = "${user.homeDir}/.local/share/.userDirs/templates";
          publicShare = "${user.homeDir}/.local/share/.userDirs/public";
        };

        dataHome = "${user.homeDir}/.local/share";
        cacheHome = "${user.homeDir}/.cache/";
        stateHome = "${user.homeDir}/.local/state";
        configHome = "${user.homeDir}/.config";
      };
    };
  };
}