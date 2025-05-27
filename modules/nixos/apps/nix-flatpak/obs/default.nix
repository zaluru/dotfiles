{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.nix-flatpak.obs;

in
{
  options.mine.apps.nix-flatpak.obs = {
    enable = mkEnableOption "Enable obs flatpak";
    
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.flatpak.packages = [
        "com.obsproject.Studio"
        # Capture vulkan and opengl games bypassing the compositor - https://github.com/nowrep/obs-vkcapture
        "com.obsproject.Studio.Plugin.OBSVkCapture"
        "org.freedesktop.Platform.VulkanLayer.OBSVkCapture//23.08"
        "org.freedesktop.Platform.VulkanLayer.OBSVkCapture//24.08"
      ];
    };
  };
}