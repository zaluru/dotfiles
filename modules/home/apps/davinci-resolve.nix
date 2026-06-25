{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.davinci-resolve;

  davinci-resolve-rusticl = pkgs.writeShellScriptBin "davinci-resolve-rusticl" ''
    env OCL_ICD_VENDORS="rusticl.icd" QT_QPA_PLATFORM="xcb" QT_PLUGIN_PATH="/etc/profiles/per-user/zaluru/lib/qt-6/plugins" davinci-resolve
  '';

  debug-desktop-env = pkgs.writeShellScriptBin "debug-desktop-env" ''
    env > /tmp/env.lst
  '';

in
{
  options.mine.apps.davinci-resolve = {
    enable = mkOpt types.bool false "Enable davinci resolve - video editing software.";
  };
  # TODO: WIP
  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = [
        pkgs.davinci-resolve-pkgs.davinci-resolve
        davinci-resolve-rusticl
        debug-desktop-env
      ];
      xdg.desktopEntries.davinci-resolve-rusticl = {
        name = "Davinci Resolve (with Rusticl)";
        genericName = "Video Editor";
        exec = "env OCL_ICD_VENDORS=rusticl.icd QT_QPA_PLATFORM=xcb QT_PLUGIN_PATH=/etc/profiles/per-user/zaluru/lib/qt-6/plugins davinci-resolve";
        icon = "davinci-resolve";
        terminal = true;
        categories = [
          "AudioVideo"
          "AudioVideoEditing"
          "Video"
          "Graphics"
        ];
        comment = "Professional video editing, color, effects and audio post-processing";
      };

      xdg.desktopEntries.debug-desktop-env = {
        name = "Debug desktop env";
        genericName = "Debug desktop env";
        exec = "debug-desktop-env";
        comment = "Professional video editing, color, effects and audio post-processing";
      };
    };
  };
}
