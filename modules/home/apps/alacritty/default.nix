{ lib, config, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.alacritty;

in
{
  options.mine.apps.alacritty = {
    enable = mkOpt types.bool false "Enable Alacritty";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {

      programs.alacritty = {
        enable = true;
        settings = {
          cursor.style = {
            shape = "Beam";
          };

          window.padding = {
            x = 10;
            y = 10;
          };

          font = {
            size = 10;
            offset = {
              x = 1;
              y = 1;
            };

            normal = {
              family = "JetBrainsMono Nerd Font";
              style = "Medium";
            };
            italic = {
              family = "JetBrainsMono Nerd Font";
              style = "Italic";
            };
            bold = {
              family = "JetBrainsMono Nerd Font";
              style = "Bold";
            };
            bold_italic = {
              family = "JetBrainsMono Nerd Font";
              style = "Bold Italic";
            };
          };
          colors = {
            cursor = {
              cursor = "#ffffff";
            };
            primary = {
              background = "#161616";
              foreground = "#ffffff";
            };
            search = {
              matches = {
                background = "#ee5396";
                foreground = "CellBackground";
              };
            };
            footer_bar = {
              background = "#262626";
              foreground = "#ffffff";
            };
            normal = {
              black = "#262626";
              blue = "#33b1ff";
              cyan = "#3ddbd9";
              green = "#42be65";
              magenta = "#ff7eb6";
              red = "#ee5396";
              white = "#dde1e6";
              yellow = "#ffe97b";
            };
            bright = {
              black = "#393939";
              blue = "#33b1ff";
              cyan = "#3ddbd9";
              green = "#42be65";
              magenta = "#ff7eb6";
              red = "#ee5396";
              white = "#ffffff";
              yellow = "#ffe97b";
            };
          };
        };
      };
    };
  };
}
