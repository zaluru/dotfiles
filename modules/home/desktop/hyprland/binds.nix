{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER,RETURN,exec,alacritty"
      "SUPER,Q,killactive,"
      "SUPER,E,exec,thunar"
      "SUPER, F, fullscreen,"
      "SUPER, Space, togglefloating,"
      "SUPER,d,exec,pkill tofi || tofi-drun | xargs -I _ hyprctl dispatch exec '_'"
      "SUPER, C, exec, hyprctl dispatch centerwindow none"
      "SUPER SHIFT, E, exit,"
      # "SUPERSHIFT, c ,exec, hyprpicker -a
      "SUPERSHIFT, c, killactive,"

      # Web browsers
      "SUPER,w,exec,firefox"
      "SUPER SHIFT,w,exec,chromium --incognito"

      "SUPER, G, togglesplit"

      ",Print,exec,screenshoterino"
      "SUPER,Print,exec,screenshoterino select"

      "SUPER,F3, exec, alacritty --command tty-clock -sc"

      "SUPER,P,pseudo,"

      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"

      "SUPER SHIFT, left, movewindow, l"
      "SUPER SHIFT, right, movewindow, r"
      "SUPER SHIFT, up, movewindow, u"
      "SUPER SHIFT, down, movewindow, d"

      "SUPER CTRL, left, resizeactive, -20 0"
      "SUPER CTRL, right, resizeactive, 20 0"
      "SUPER CTRL, up, resizeactive, 0 -20"
      "SUPER CTRL, down, resizeactive, 0 20"

      "SUPER, mouse_down, workspace, e-1"
      "SUPER, mouse_up, workspace, e+1"

      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      ", XF86AudioMedia, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioStop, exec, playerctl stop"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"
      "SUPER, 0, workspace, 10"
      "SUPER ALT, right, workspace, e+1"
      "SUPER ALT, left, workspace, e-1"

      "SUPER SHIFT, 1, movetoworkspace, 1"
      "SUPER SHIFT, 2, movetoworkspace, 2"
      "SUPER SHIFT, 3, movetoworkspace, 3"
      "SUPER SHIFT, 4, movetoworkspace, 4"
      "SUPER SHIFT, 5, movetoworkspace, 5"
      "SUPER SHIFT, 6, movetoworkspace, 6"
      "SUPER SHIFT, 7, movetoworkspace, 7"
      "SUPER SHIFT, 8, movetoworkspace, 8"
      "SUPER SHIFT, 9, movetoworkspace, 9"
      "SUPER SHIFT, 0, movetoworkspace, 10"
    ];
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    binde = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];
  };
}
