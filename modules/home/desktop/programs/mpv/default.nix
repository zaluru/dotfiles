{ ... }:

{
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

}
