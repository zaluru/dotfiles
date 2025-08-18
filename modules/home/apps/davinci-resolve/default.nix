{ lib, config, pkgs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.davinci-resolve;

  davinci-resolve-rusticl = pkgs.writeShellScriptBin "davinci-resolve-rusticl" ''
    env OCL_ICD_VENDORS="rusticl.icd" QT_QPA_PLATFORM="xcb" QT_PLUGIN_PATH="/etc/profiles/per-user/zaluru/lib/qt-6/plugins" davinci-resolve
  '';
in
{
  options.mine.apps.davinci-resolve = {
    enable = mkOpt types.bool false "Enable davinci resolve - video editing software.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = [ pkgs.davinci-resolve-pkgs.davinci-resolve davinci-resolve-rusticl ];
    };
  };
}