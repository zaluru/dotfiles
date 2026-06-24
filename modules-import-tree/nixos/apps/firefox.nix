{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.firefox;

in
{
  options.mine.apps.firefox = {
    enable = mkEnableOption "Install Firefox";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.firefox = {
        enable = true;
        # TODO: This is not a home manager moudle so config references the system config, have to think about how to aproach this
        configPath = "${config.home-manager.users.${user.name}.xdg.configHome}/mozilla/firefox";
        profiles = {
          default = {
            id = 0;
            name = "default";
            isDefault = true;
            settings = {
              "sidebar.verticalTabs" = true;
              "sidebar.position_start" = false; # Move sidebar to the right
              "widget.use-xdg-desktop-portal.file-picker" = 1;
              "browser.aboutConfig.showWarning" = false;
              "signon.rememberSignons" = false;
              "browser.tabs.inTitlebar" = 0;
            };
            search = {
              force = true;
              default = "Brave Search";
              privateDefault = "Brave Search";

              engines = {
                "Brave Search" = {
                  urls = [
                    {
                      template = "https://search.brave.com/search";
                      params = [
                        {
                          name = "q";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                };

                "Nix Packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "Nix Options" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@no" ];
                };

                "Home Manager" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = [
                        {
                          name = "source";
                          value = "home_manager";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@hm" ];
                };

                "NixOS Wiki" = {
                  urls = [
                    {
                      template = "https://wiki.nixos.org/w/index.php";
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@nw" ];
                };
                bing.metaData.hidden = true;
                google.metaData.hidden = true;
                ddg.metaData.hidden = true;
                "ebay-pl".metaData.hidden = true;
                perplexity.metaData.hidden = true;
                wikipedia.metaData.hidden = true;
              };
            };
          };
        };
      };
    };

    programs.firefox = {
      enable = true;

      # Documented at about:policies and https://firefox-admin-docs.mozilla.org/reference/policies/
      policies = {

        ExtensionSettings =
          let
            moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
          in
          {
            "*".installation_mode = "blocked";

            "uBlock0@raymondhill.net" = {
              install_url = moz "ublock-origin";
              installation_mode = "force_installed";
              updates_disabled = true;
            };

          };

        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        OverrideFirstRunPage = "";
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAccounts = true;
        DisableFirefoxAccounts = true;
        DisableBuiltinPDFViewer = true;
        AIControls.Default.Value = "blocked";
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        NoDefaultBookmarks = true;
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          FirefoxLabs = false;
          Locked = true;
        };
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
        };
      };
    };
  };
}
