{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.zed;

in
{
  options.mine.apps.zed = {
    enable = mkEnableOption "Zed editor";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.zed-editor = {
        enable = true;
        extraPackages = [ pkgs.nixd ];
        extensions = [ "nix" "toml" "rust" "rose-pine-theme" ];
        userSettings = {
          theme = {
            mode = "system";
            dark = "Rosé Pine";
            light = "Rosé Pine Dawn";
          };
          hour_format = "hour24";
          vim_mode = true;
          agent = {
            enabled = false;
          };

          title_bar = {
            show_branch_icon = true;
            show_branch_name = true;
            show_project_items = true;
            show_onboarding_banner = false;
            show_user_picture = true;
            show_sign_in = false;
          };

          disable_ai = true;

          telemetry = {
            metrics = false;
            diagnostics = false;
          };
        };
        installRemoteServer = true;
      };
    };
  };
}

