{ pkgs, inputs, ... }:

{
  #imports = [./fonts.nix ./services.nix ./pipewire.nix];
  imports = [
    ./services.nix
    ./dwm.nix
    inputs.hyprland.nixosModules.default
  ];
  # nixpkgs.overlays = with inputs; [nixpkgs-wayland.overlay];

  # For gaming
  #TODO: read more about Jovian NixOS, maybe use their config
  hardware.steam-hardware.enable = true;
  programs = {
    steam = {
      enable = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };
  environment = {
    variables = {
      # TODO those should be desktop specific variables, have to look into them
      # TODO have to check out how to set the env variables for apps launched from an app launcher like toffi https://github.com/nix-community/home-manager/issues/1011
      #XDG_CACHE_HOME = "/home/zaluru/.local/cache";
      #EDITOR="emacsclient -t -a ''";
      #VISUAL="emacsclient -c -a emacs";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
      QT_SCALE_FACTOR = "1";
      MOZ_WEBRENDER = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      _JAVA_AWT_WM_NONEREPARENTING = "1";
      DISABLE_QT5_COMPAT = "0";
      DIRENV_LOG_FORMAT = "";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      #QT_QPA_PLATFORMTHEME = lib.mkForce "qt5ct";
      #QT_STYLE_OVERRIDE = lib.mkForce "kvantum";
      #WLR_BACKEND = "vulkan";
      #WLR_RENDERER = "vulkan";
      #WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    };
    loginShellInit = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
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
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  sound = {
    # TODO Don't think this is required - this will enable ALSA but pipewire should already do something with this
    #enable = true;
    mediaKeys.enable = true;
  };

  programs = {
    # From what I read the system module should be enabled, but i set the package to null, so hyprland will use the home manager package
    hyprland = {
      enable = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
  };
}
