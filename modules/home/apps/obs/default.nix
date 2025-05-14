{ lib, config, pkgs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.obs;

in
{
  options.mine.apps.obs = {
    enable = mkOpt types.bool false "Enable OBS";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.obs-studio = {
        enable = true;
        plugins = [
          pkgs.obs-studio-plugins.obs-vaapi
          pkgs.obs-studio-plugins.obs-vkcapture

          # Merge request to the obs project - https://github.com/obsproject/obs-studio/pull/6207
          # Capturing multiple apps (not released) - https://github.com/dimtpap/obs-pipewire-audio-capture/issues/24 
          pkgs.obs-studio-plugins.obs-pipewire-audio-capture
        ];
      };
    };
  };
}