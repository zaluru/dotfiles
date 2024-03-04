{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    env = [
      "GDK_BACKEND,wayland,x11"
      "QT_QPA_PLATFORM,wayland;xcb"
      "SDL_VIDEODRIVER,wayland"
      "CLUTTER_BACKEND,wayland"
      "MOZ_ENABLE_WAYLAND,1"
      "ANKI_WAYLAND,1"
      "NIXOS_OZONE_WL,1"

      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"

      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      #"QT_QPA_PLATFORMTHEME,qt5ct" # TODO make it work properly, currently setting this variable breaks chromium based apps
      "WLR_DRM_NO_ATOMIC,1"
      "WLR_NO_HARDWARE_CURSORS,1"
    ];

    exec-once = [ "autostart-hyprland" ];

    monitor = ",preferred,auto,1,bitdepth,10"; # why the fuck does that fix obs xdd

    general = {
      sensitivity = 1.0;
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(78a9ffee)";
      "col.inactive_border" = "rgba(262626ee)";
      apply_sens_to_raw = 0;
      layout = "dwindle";
    };

    dwindle = {
      pseudotile = 1; # enable pseudotiling on dwindle
      force_split = 0;
    };

    master = {
      new_is_master = true;
      no_gaps_when_only = true;
    };

    input = {
      kb_layout = "pl";
      follow_mouse = 0;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };
  };
}
