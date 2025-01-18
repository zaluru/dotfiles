{ inputs, ... }:

{
  # Move those imports
  imports = [
    ../default.nix
    ../programs/default.nix
    ../programs/dunst
    ../programs/waybar
    ../programs/defaultApps.nix
    ../programs/tofi
  ];

  xdg.configFile = {
    "plasma-workspace/env/session-variables.sh".text = ''
      export GDK_BACKEND=wayland,x11
      export QT_QPA_PLATFORM=wayland;xcb
      #export SDL_VIDEODRIVER=wayland # Disable this for gamescope though - https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
      export CLUTTER_BACKEND=wayland
      export MOZ_ENABLE_WAYLAND=1
      export ANKI_WAYLAND=1
      export NIXOS_OZONE_WL=1
    '';
  };

  # TODO: disable desktop icons when this is completed - https://github.com/nix-community/plasma-manager/issues/117
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };
    kwin.virtualDesktops.names = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
    window-rules = [
      {
        description = "Remove title bar";
        match = {
          window-class = {
            value = ".*";
            type = "regex";
          };
        };
        apply = {
          noborder = {
            value = true;
            apply = "force";
          };
        };
      }
    ];
    # You can find shortcuts names in ~/.config/kglobalshortcutsrc
    shortcuts = {
      #"" = "Meta"; #TODO: Unbind Meta from application launcher
      kwin = {
        "Window Close" = "Meta+Shift+C";
      };
    };
    panels = [
      {
        location = "top";
        screen = 1; # Display only on second monitor
        height = 26;
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          "org.dhruv8sh.kara"
          {
            applicationTitleBar = {
              behavior = {
                # I have always a single instance of this wdiget on a single display
                # Without those options it will not report the active window on a second screen etc.
                activeTaskSource = "activeTask";
                filterByActivity = false;
                filterByScreen = false;
                filterByVirtualDesktop = false;
              };
              mouseAreaDrag.enable = false;
              mouseAreaClick.enable = false;
              mouseAreaWheel.enable = false;
              layout = {
                elements = [ "windowTitle" ];
                horizontalAlignment = "left";
                showDisabledElements = "deactivated";
                verticalAlignment = "center";
              };
              overrideForMaximized.enable = false;
              titleReplacements = [
                {
                  type = "regexp";
                  originalTitle = "^Brave Web Browser$";
                  newTitle = "Brave";
                }
                {
                  type = "regexp";
                  originalTitle = ''\\bDolphin\\b'';
                  newTitle = "File manager";
                }
              ];
              windowTitle = {
                font = {
                  bold = false;
                  fit = "fixedSize";
                  size = 12;
                };
                hideEmptyTitle = true;
                undefinedWindowTitle = "";
                margins = {
                  bottom = 0;
                  left = 10;
                  right = 5;
                  top = 0;
                };
                source = "appName";
              };
            };
          }
          "org.kde.plasma.panelspacer"
          {
            plasmusicToolbar = {
              panelIcon = {
                albumCover = {
                  useAsIcon = false;
                  radius = 8;
                };
                icon = "view-media-track";
              };
              playbackSource = "auto";
            };
          }
          {
            systemTray = {
              # To find the identifiers of the tray elements check ~/.config/plasma-org.kde.plasma.desktop-appletsrc
              items = {
                hidden = [
                  "steam"
                  "polychromatic-tray-applet"
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.notifications"
                  "xdg-desktop-portal-kde"

                  # Ehh electron
                  # https://github.com/electron/electron/issues/40936
                  "chrome_status_icon_1"
                ];
              };
              icons = {
                spacing = "small";
              };
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              time.format = "24h";
            };
          }
        ];
      }
    ];
  };
}
