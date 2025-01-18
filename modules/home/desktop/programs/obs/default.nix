{ ... }:

{
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
}
