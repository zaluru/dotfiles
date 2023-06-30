{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  #imports = [./fonts.nix ./services.nix ./pipewire.nix];
  imports = [./services.nix];
  # nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  environment = {
    variables = {
      # TODO those should be desktop specific variables, have to look into them
      # TODO have to check out how to set the env variables for apps launched from an app launcher like toffi https://github.com/nix-community/home-manager/issues/1011
      #XDG_CACHE_HOME = "/home/zaluru/.local/cache";
      #EDITOR="emacsclient -t -a ''";
      #VISUAL="emacsclient -c -a emacs";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      NIXOS_OZONE_WL = "1";
      QT_SCALE_FACTOR = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      _JAVA_AWT_WM_NONREPARENTING= "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      _JAVA_AWT_WM_NONEREPARENTING = "1";
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      DISABLE_QT5_COMPAT = "0";
      GDK_BACKEND = "wayland";
      ANKI_WAYLAND = "1";
      DIRENV_LOG_FORMAT = "";
      WLR_DRM_NO_ATOMIC = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORMTHEME = lib.mkForce "qt5ct";
      QT_STYLE_OVERRIDE = lib.mkForce "kvantum";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";

    };
    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
      eval $(gnome-keyring-daemon --start --components=ssh)
      eval $(ssh-agent)
    '';
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    #pulseaudio.support32Bit = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      # TODO conflicts with the hyprland portal
      #pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    ];
  };

  sound = {
    # TODO Don't think this is required - this will enable ALSA but pipewire should already do something with this
    #enable = true;
    mediaKeys.enable = true;
  };

  programs. thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };
}
