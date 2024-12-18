{ ... }:

{
  #programs.obs-studio = {
  #  enable = true;
  #};

  #services.flatpak = {
  #  packages = [
  #    "com.obsproject.Studio"
  #    # Capture vulkan and opengl games bypassing the compositor - https://github.com/nowrep/obs-vkcapture
  #    "com.obsproject.Studio.Plugin.OBSVkCapture"
  #    "org.freedesktop.Platform.VulkanLayer.OBSVkCapture"
  #  ];
  #};
}
