{ lib, config, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.cli-tools.zellij;

in
{
  options.mine.cli-tools.zellij = {
    enable = mkEnableOption "Enable Zellij";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {

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
              bg = "#262625";
              fg = "#dde0e6";
              red = "#da0e28";
              green = "#41be65";
              blue = "#32b1ff";
              yellow = "#FFAB90";
              magenta = "#ff6eb6";
              orange = "#FF5F00";
              cyan = "#2ddbd9";
              black = "#161615";
              white = "#ffffff";
            };
          };
        };
      };
    };
  };
}