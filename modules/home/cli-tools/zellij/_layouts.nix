{ inputs, pkgs, ... }:
let
  zjstatus =
    (import inputs.unstable {
      inherit (pkgs) config;
      inherit (pkgs.stdenv.hostPlatform) system;
    }).zellijPlugins.zjstatus;
in
{
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        pane split_direction="vertical" {
            pane
        }

        pane size=1 borderless=true {
            plugin location="file:${zjstatus}" {
                format_left  "{mode} #[fg=#89B4FA,bold]{session} {tabs}"
                format_right "{command_git_branch} {datetime}"
                format_space ""

                border_enabled  "false"
                border_char     "─"
                border_format   "#[fg=#6C7086]{char}"
                border_position "top"

                hide_frame_for_single_pane "true"

                mode_normal  "#[bg=blue] "
                mode_tmux    "#[bg=#ffc387] "

                tab_normal   "#[fg=#6C7086] {name} "
                tab_active   "#[fg=#9399B2,bold,italic] {name} "

                command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                command_git_branch_format      "#[fg=blue] {stdout} "
                command_git_branch_interval    "10"
                command_git_branch_rendermode  "static"

                datetime        "#[fg=#6C7086,bold] {format} "
                datetime_format "%A, %d %b %Y %H:%M"
                datetime_timezone "Europe/Berlin"
            }
        }
    }
  '';
  xdg.configFile."zellij/layouts/godot.kdl".text = ''
    layout {
        default_tab_template {
            pane size=1 borderless=true {
                plugin location="zellij:tab-bar"
            }
            children
            pane size=2 borderless=true {
                plugin location="zellij:status-bar"
            }
        }
        tab name="XGodot engine (process)" {
            pane command="nvidia-offload" {
                args "godot4"
            }
        }
        tab name="main" focus="true" {
            pane {
                pane split_direction="Vertical" {
                   pane
                   pane
                }
                pane
            }
        }
    }
  '';
}
