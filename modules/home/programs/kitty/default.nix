{ ... }:

{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    #font.name = "JetBrainsMono Nerd Font";
    #font.size = 10;
    settings = {
      enable_audio_bell = "no";
      confirm_os_window_close = 0;
      window_padding_width = 5;
    };
  };
}
