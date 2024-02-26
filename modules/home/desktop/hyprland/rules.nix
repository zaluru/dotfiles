{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    animations = {
      enabled = 1;
      bezier = "simple, 0.13, 0.99, 0.29, 1.0";
      animation = [
        "windows, 1, 3, simple, slide"
        "border, 1, 10, simple"
        "fade, 1, 0.98, simple"
        "workspaces, 1, 3, simple, slide"
      ]; 
    };

    decoration = { 
      rounding = 0;
      drop_shadow = 0;
      shadow_range = 30;
      shadow_render_power = 5;
      "col.shadow" = "0xffed8796 0xfff4dbd6 0xffeed49f 0xff8aadf4 10deg";
      "col.shadow_inactive" = "0xaa45475a";
      blur = {
	      size = 1;
	      passes = 1;
      };
      active_opacity = 1;
      inactive_opacity = 1;
    };

    windowrule = [
      "center,title:^(kitty)$"
      "size 790 500,title:^(kitty)$"
      "animation slide,title:^(kitty)$"
      "float,title:^(kitty)$"
      "float, title:^(alert)$"
      "float, title:^(notification)$"
      "float, title:^(copy)$"
      "float, title:^(delete)$"
      "float, title:^(move)$"
      "float, title:^(cut)$"
      "float,thunar"
      "float,pavucontrol"
      "pseudo,abc"
      "opacity 1.0 override 1.0 override,^(vlc)$"
    ];

    windowrulev2 = [
      "opacity 0.95 0.95,class:^(Alacritty)$"
      "float, class:^(firefox)$, title:^(Firefox — Sharing Indicator)$"
      "noanim,floating:1" # Disables animations on floating windows
    ];
  };
}
