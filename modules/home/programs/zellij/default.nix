{ ... }:

{
  imports = [ ./layouts.nix ];

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      default_layout = "default";
      pane_frames = false; # TODO for some reasone changing default_layout ignores the pane_frames option, and i don't know how to set it in the layout.
      simplified_ui = true;
      theme = "oxocarbon";
      themes = {
        oxocarbon = {
          bg = "#262626";
          fg = "#dde1e6";
          red = "#da1e28";
          green = "#42be65";
          blue = "#33b1ff";
          yellow = "#FFAB91";
          magenta = "#ff7eb6";
          orange = "#FF6F00";
          cyan = "#3ddbd9";
          black = "#161616";
          white = "#ffffff";
        };
      };
    };
  };
}
