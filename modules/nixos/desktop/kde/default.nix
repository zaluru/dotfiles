{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.desktop.kde;

in
{
  options.mine.desktop.kde = {
    enable = mkOpt types.bool false "KDE";
  };

  config = mkIf cfg.enable {
    environment = {
      # Disable baloo indexing - used by KDE apps, i had terrible performance with this enabled, also I don't need it
      etc."xdg/baloofilerc".source = (pkgs.formats.ini { }).generate "baloorc" {
        "Basic Settings" = {
          "Indexing-Enabled" = false;
        };
      };

      plasma6.excludePackages = with pkgs.kdePackages; [
        konsole
        elisa
        gwenview
        okular
        kate
        khelpcenter
        baloo-widgets
        discover
        #spectacle
        #ark
      ];
    };

    services.desktopManager.plasma6.enable = true;

    home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

    home-manager.users.${user.name} = {
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      };

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

      # TODO: https://github.com/nix-community/plasma-manager/issues/419
      home.packages = with pkgs; [
        kdePackages.krohnkite
        pkgs.kdePackages.partitionmanager
        pkgs.exfatprogs # Required for partitionmanager to support exfat
        inputs.self.packages.${pkgs.system}.klassy-qt6
      ];

      # TODO: disable desktop icons when this is completed - https://github.com/nix-community/plasma-manager/issues/117
      # TODO: gtkrc problem - https://github.com/nix-community/plasma-manager/issues/472
      programs = {
        plasma = {
          enable = true;
          workspace = {
            lookAndFeel = "org.kde.breezedark.desktop";
          };
          kwin.virtualDesktops.names = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
          configFile = {
            # Keyboard layout
            "kxkbrc"."Layout"."LayoutList" = "pl";
            "kxkbrc"."Layout"."Use" = true;

            # Notifications
            "plasmanotifyrc"."Notifications"."PopupPosition" = "TopRight";

            # Dolphin
            "dolphinrc"."DetailsMode"."PreviewSize" = 16;
            "dolphinrc"."DetailsMode"."SidePadding" = 0;
            "dolphinrc"."General/$i"."Version[$i]" = 202;
            "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
            "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
            "dolphinrc"."PreviewSettings"."Plugins" = "mltpreview,appimagethumbnail,audiothumbnail,comicbookthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,opendocumentthumbnail,svgthumbnail,windowsexethumbnail,windowsimagethumbnail,directorythumbnail";

            # File dialog options
            "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
            "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
            "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = false;
            "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
            "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
            "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
            "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
            "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
            "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
            "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
            "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
            "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
            "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
            "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
            "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
            "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
            "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 140;
            "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";

            # Another baloo disabling just to be sure
            "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;

            # Mouse
            "kcminputrc"."Libinput/5426/138/Razer Razer Viper Mini"."PointerAcceleration" = 0.000;
            "kcminputrc"."Libinput/5426/138/Razer Razer Viper Mini"."PointerAccelerationProfile" = 1;
            
            # Look and feel
            "kdeglobals"."General"."AccentColor" = "73,43,91";
            "kdeglobals"."KDE"."AnimationDurationFactor" = 0.17677669529663687;
            "kdeglobals"."KDE"."ShowDeleteCommand" = false;
            "kdeglobals"."General"."UseSystemBell" = true;
            "kdeglobals"."PreviewSettings"."MaximumRemoteSize" = 0; # Not sure what that is
            "kwinrc"."Effect-slide"."SlideBackground" = false;
            "kwinrc"."Effect-translucency"."MoveResize" = 63;
            "kwinrc"."Plugins"."shakecursorEnabled" = false; # Enlarges the cursor when shaking
            "kwinrc"."Plugins"."desktopchangeosdEnabled" = false; # Displa

            # Krohnkite tiling
            "kwinrc"."Plugins"."krohnkiteEnabled" = true;
            "kwinrc"."Script-krohnkite"."enableStackedLayout" = true;
            "kwinrc"."Script-krohnkite"."screenDefaultLayout" = "DP-1:tilelayout,DP-1:3:stackedlayout,DP-2:stackedlayout";
            "kwinrc"."Script-krohnkite"."screenGapBottom" = 10;
            "kwinrc"."Script-krohnkite"."screenGapLeft" = 10;
            "kwinrc"."Script-krohnkite"."screenGapRight" = 10;
            "kwinrc"."Script-krohnkite"."screenGapTop" = 10;
            #"kwinrc"."Script-krohnkite"."tileLayoutGap" = 10;
            "kwinrc"."Script-krohnkite"."screenGapBetween" = 10;
            #"kwinrc"."Script-krohnkite"."maximizeSoleTile" = true;
            "kwinrc"."Script-krohnkite"."soleWindowNoBorders" = true;
            "kwinrc"."Script-krohnkite"."soleWindowNoGaps" = true;

            # Enable klassy for borders
            "kwinrc"."org.kde.kdecoration2"."theme" = "Klassy";
            # Configure ~/.config/Klassy

            # Terminal application
            "kdeglobals"."General"."TerminalApplication" = "alacritty";
            "kdeglobals"."General"."TerminalService" = "Alacritty.desktop";

            "kiorc"."Confirmations"."ConfirmDelete" = true;
            "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
            "kiorc"."Confirmations"."ConfirmTrash" = false;
            "kiorc"."Executable scripts"."behaviourOnLaunch" = "alwaysAsk";

            # Screen locker
            "kscreenlockerrc"."Daemon"."Autolock" = false;
            "kscreenlockerrc"."Daemon"."Timeout" = 0;

            "kservicemenurc"."Show"."RunGhosttyDir" = true;
            "kservicemenurc"."Show"."forgetfileitemaction" = true;
            "kservicemenurc"."Show"."installFont" = true;
            "kservicemenurc"."Show"."kactivitymanagerd_fileitem_linking_plugin" = true;
            "kservicemenurc"."Show"."runInKonsole" = true;
            "kservicemenurc"."Show"."tagsfileitemaction" = true;
            "ksmserverrc"."General"."loginMode" = "emptySession";

            # krunner
            "krunnerrc"."General"."FreeFloating" = true;
            "krunnerrc"."General"."ActivateWhenTypingOnDesktop" = false;
            "krunnerrc"."Plugins"."baloosearchEnabled" = false;
            "krunnerrc"."Plugins"."browserhistoryEnabled" = false;
            "krunnerrc"."Plugins"."browsertabsEnabled" = false;
            "krunnerrc"."Plugins"."calculatorEnabled" = false;
            "krunnerrc"."Plugins"."helprunnerEnabled" = false;
            "krunnerrc"."Plugins"."krunner_appstreamEnabled" = false;
            "krunnerrc"."Plugins"."krunner_bookmarksrunnerEnabled" = false;
            "krunnerrc"."Plugins"."krunner_charrunnerEnabled" = false;
            "krunnerrc"."Plugins"."krunner_dictionaryEnabled" = false;
            "krunnerrc"."Plugins"."krunner_katesessionsEnabled" = false;
            "krunnerrc"."Plugins"."krunner_killEnabled" = false;
            "krunnerrc"."Plugins"."krunner_konsoleprofilesEnabled" = false;
            "krunnerrc"."Plugins"."krunner_kwinEnabled" = false;
            "krunnerrc"."Plugins"."krunner_placesrunnerEnabled" = false;
            "krunnerrc"."Plugins"."krunner_plasma-desktopEnabled" = false;
            "krunnerrc"."Plugins"."krunner_powerdevilEnabled" = false;
            "krunnerrc"."Plugins"."krunner_recentdocumentsEnabled" = false;
            "krunnerrc"."Plugins"."krunner_sessionsEnabled" = false;
            "krunnerrc"."Plugins"."krunner_shellEnabled" = false;
            "krunnerrc"."Plugins"."krunner_spellcheckEnabled" = false;
            "krunnerrc"."Plugins"."krunner_webshortcutsEnabled" = false;
            "krunnerrc"."Plugins"."locationsEnabled" = false;
            "krunnerrc"."Plugins"."org.kde.activities2Enabled" = false;
            "krunnerrc"."Plugins"."org.kde.datetimeEnabled" = false;
            "krunnerrc"."Plugins"."unitconverterEnabled" = false;
            "krunnerrc"."Plugins"."windowsEnabled" = false;
          };
          window-rules = [
            # The screen window rule seems to be broken, to hack around it i set the initial position = "1920,0", so that it starts on the second screen
            {
              description = "Brave";
              match = {
                window-class.value = "brave brave-browser";
              };
              apply = {
                desktops.value = "Desktop_2";
              };
            }
            {
              description = "Firefox";
              match = {
                window-class.value = "firefox firefox";
              };
              apply = {
                desktops.value = "Desktop_2";
              };
            }
            {
              description = "Steam";
              match = {
                window-class.value = "steamwebhelper steam";
              };
              apply = {
                desktops.value = "Desktop_3";
              };
            }
            {
              description = "KeepassXC";
              match = {
                window-class.value = "keepassxc org.keepassxc.KeePassXC";
              };
              apply = {
                desktops.value = "Desktop_8";
                position.value = "1920,0";
              };
            }
            {
              description = "Bitwarden";
              match = {
                window-class.value = "electron Bitwarden";
              };
              apply = {
                desktops.value = "Desktop_8";
                position.value = "1920,0";
              };
            }
            {
              description = "Discord";
              match = {
                window-class.value = "Discord discord";
              };
              apply = {
                desktops.value = "Desktop_9";
                position.value = "1920,0";
              };
            }
            {
              description = "Element";
              match = {
                window-class.value = "electron Element";
              };
              apply = {
                desktops.value = "Desktop_9";
                position.value = "1920,0";
              };
            }
            {
              description = "Signal";
              match = {
                window-class.value = "electron signal";
              };
              apply = {
                desktops.value = "Desktop_9";
                position.value = "1920,0";
              };
            }
          ];
          # You can find shortcuts names in ~/.config/kglobalshortcutsrc
          shortcuts = {
            kwin = {
              "Window Close" = "Meta+Shift+C";
              "view_actual_size" = "Meta+0";

              "Window to Desktop 1" = "Meta+!";
              "Window to Desktop 2" = "Meta+@";
              "Window to Desktop 3" = "Meta+#";
              "Window to Desktop 4" = "Meta+$";
              "Window to Desktop 5" = "Meta+%";
              "Window to Desktop 6" = "Meta+^";
              "Window to Desktop 7" = "Meta+&";
              "Window to Desktop 8" = "Meta+*";
              "Window to Desktop 9" = "Meta+(";
              "Window to Desktop 10" = "Meta+)";

              "Switch to Desktop 1" = "Meta+1";
              "Switch to Desktop 2" = "Meta+2";
              "Switch to Desktop 3" = "Meta+3";
              "Switch to Desktop 4" = "Meta+4";
              "Switch to Desktop 5" = "Meta+5";
              "Switch to Desktop 6" = "Meta+6";
              "Switch to Desktop 7" = "Meta+7";
              "Switch to Desktop 8" = "Meta+8";
              "Switch to Desktop 9" = "Meta+9";
              "Switch to Desktop 10" = "Meta+0";

              "Show Desktop" = [ ];
              # TODO: seems to be breaking tiling with krohnkite currently :C
              #"Window On All Desktops" = "Meta+Shift+D";
              "Window On All Desktops" = [ ];


              "KrohnkiteBTreeLayout" = [ ];
              "KrohnkiteColumnsLayout" = [ ];
              "KrohnkiteDecrease" = [ ];
              "KrohnkiteFloatAll" = "Meta+Shift+F";
              "KrohnkiteFloatingLayout" = [ ];
              "KrohnkiteFocusDown" = "Meta+J";
              "KrohnkiteFocusLeft" = "Meta+H";
              "KrohnkiteFocusNext" = [ ];
              "KrohnkiteFocusPrev" = "Meta+\\";
              "KrohnkiteFocusRight" = [ ];
              "KrohnkiteFocusUp" = "Meta+K";
              "KrohnkiteGrowHeight" = "Meta+Ctrl+J";
              "KrohnkiteIncrease" = "Meta+I";
              "KrohnkiteMonocleLayout" = "Meta+M";
              "KrohnkiteNextLayout" = "Meta+\\\\";
              "KrohnkitePreviousLayout" = "Meta+|";
              "KrohnkiteQuarterLayout" = [ ];
              "KrohnkiteRotate" = [ ];
              "KrohnkiteRotatePart" = [ ];
              "KrohnkiteSetMaster" = "Meta+Return";
              "KrohnkiteShiftDown" = "Meta+Shift+J";
              "KrohnkiteShiftLeft" = "Meta+Shift+H";
              "KrohnkiteShiftRight" = "Meta+Shift+L";
              "KrohnkiteShiftUp" = "Meta+Shift+K";
              "KrohnkiteShrinkHeight" = "Meta+Ctrl+K";
              "KrohnkiteShrinkWidth" = "Meta+Ctrl+H";
              "KrohnkiteSpiralLayout" = [ ];
              "KrohnkiteSpreadLayout" = [ ];
              "KrohnkiteStackedLayout" = [ ];
              "KrohnkiteStairLayout" = [ ];
              "KrohnkiteTileLayout" = [ ];
              "KrohnkiteToggleFloat" = "Meta+F";
              "KrohnkiteTreeColumnLayout" = [ ];
              "KrohnkitegrowWidth" = "Meta+Ctrl+L";
            };

            plasmashell = {
              "activate task manager entry 1" = [ ];
              "activate task manager entry 2" = [ ];
              "activate task manager entry 3" = [ ];
              "activate task manager entry 4" = [ ];
              "activate task manager entry 5" = [ ];
              "activate task manager entry 6" = [ ];
              "activate task manager entry 7" = [ ];
              "activate task manager entry 8" = [ ];
              "activate task manager entry 9" = [ ];
              "activate task manager entry 10" = [ ];

              "activate application launcher" = [ ];
            };

            kaccess = {
              "Toggle Screen Reader On and Off" = [ ];
            };

            "services/Alacritty.desktop" = {
              "New" = "Meta+Shift+Return";
            };
            # Untill i find a way to integrate tofi or other launchers better
            "services/org.kde.krunner.desktop" = {
              "_launch" = "Meta+D";
            };
          };
          dataFile = {
            "dolphin/view_properties/global/.directory"."Dolphin"."SortOrder" = 1;
            "dolphin/view_properties/global/.directory"."Dolphin"."SortRole" = "creationtime";
            "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
            "dolphin/view_properties/global/.directory"."Dolphin"."VisibleRoles" = "CustomizedDetails,Details_text,Details_size,Details_creationtime,Details_type";
          };

          powerdevil.AC = {
            autoSuspend.action = "nothing";
            dimDisplay.enable = false;
            turnOffDisplay.idleTimeout = "never";
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
                        "A PipeWire Graph Qt GUI Interface" # qpwgraph
                        "org.kde.plasma.mediacontrolle"

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
          startup.desktopScript."configure_kara" = {
            # can debug with command - plasma-interactiveconsole
            # https://develop.kde.org/docs/plasma/scripting/
            # kara saves changes to ~/.config/plasma-org.kde.plasma.desktop-appletsrc
            text = ''
              function forEachWidgetInContainmentList(containmentList, callback) {
                for (const containment of containmentList) {
                  for (const widget of containment.widgets()) {
                    callback(widget, containment);
                    if (widget.type === "org.kde.plasma.systemtray") {
                      const systemtrayId = widget.readConfig("SystrayContainmentId");
                      if (systemtrayId) {
                        const systrayContainment = desktopById(systemtrayId);
                        if (systrayContainment) {
                          forEachWidgetInContainmentList([systrayContainment], callback);
                        }
                      }
                    }
                  }
                }
              }

              function forEachWidget(callback) {
                forEachWidgetInContainmentList(desktops(), callback);
                forEachWidgetInContainmentList(panels(), callback);
              }

              function forEachWidgetByType(type, callback) {
                forEachWidget((widget, containment) => {
                  if (widget.type === type) {
                    callback(widget, containment);
                  }
                });
              }

              function widgetSetProperty({ widgetType, configGroup, configKey, configValue }) {
                if (!(widgetType && configGroup && configKey)) return;

                forEachWidgetByType(widgetType, (widget) => {
                  widget.currentConfigGroup = [configGroup];
                  widget.writeConfig(configKey, configValue);
                });
              }

              const settings = [
                { configGroup: "general", configKey: "spacing", configValue: "0" },
                { configGroup: "general", configKey: "highlightType", configValue: "1" },
                { configGroup: "type2", configKey: "fixedLen", configValue: "20" },
                { configGroup: "type2", configKey: "template", configValue: "%d" },
                { configGroup: "ConfigDialog", configKey: "DialogWidth", configValue: "720" },
                { configGroup: "ConfigDialog", configKey: "DialogHeight", configValue: "540" },
                { configGroup: "appearance", configKey: "plasmaStyleColors", configValue: "false"},
                { configGroup: "appearance", configKey: "plasmaSemiColors", configValue: "false"},
                { configGroup: "appearance", configKey: "pColor", configValue: "107,67,178"},
                { configGroup: "appearance", configKey: "semiColor", configValue: "103,58,183"},
              ];

              for (var i = 0; i < settings.length; i++) {
                var setting = settings[i];
                widgetSetProperty({
                  widgetType: "org.dhruv8sh.kara",
                  configGroup: setting.configGroup,
                  configKey: setting.configKey,
                  configValue: setting.configValue,
                });
              }
            '';
            priority = 3;
            restartServices = [ "plasma-plasmashell" ];
          };
        };
      };
    };
  };
}
