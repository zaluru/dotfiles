{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.audio.pipewire;

in
{
  options.mine.system.audio.pipewire = {
    enable = mkEnableOption "Enable pipewire audio";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.pavucontrol
    ];


    # Pipewire
    # TODO there is some crackling noise in discord, propably related to those:
    # https://www.reddit.com/r/linux_gaming/comments/vg8gl2/comment/id4liim/
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2476
    # rtkit is optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
