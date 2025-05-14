{ lib, config, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.mpv;

in
{
  options.mine.apps.mpv = {
    enable = mkOpt types.bool false "Enable mpv";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.mpv = {
        enable = true;
        config = {
          # mpv hardware acceleration
          hwdec = "auto-safe";
          profile = "gpu-hq";
          vo = "gpu";

          gpu-context = "wayland";

          force-window = true;
        };
      };
    };
  };
}