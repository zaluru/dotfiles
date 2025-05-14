{ lib, config, pkgs, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.apps.brave;

in
{
  options.mine.apps.brave = {
    enable = mkEnableOption "Install Brave browser";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.brave = {
        enable = true;
        package = pkgs.brave.override { 
          commandLineArgs = "--enable-features=VaapiVideoDecodeLinuxGL,WebRTCPipeWireCapturer";
        };
      };

      # TODO: check if im not able to do the same in a simpler/more nix way
      #home.file.".var/app/com.brave.Browser/config/source-brave-flags.conf" = {
      #  text = ''
      #    --ozone-platform=wayland
      #    --enable-features=VaapiVideoDecodeLinuxGL,WebRTCPipeWireCapturer
      #  '';
      #  # have to copy it from the symlink becouse the flatpak has no permission to read the nix store
      #  onChange = ''
      #    rm -f ~/.var/app/com.brave.Browser/config/brave-flags.conf
      #    cp -L ~/.var/app/com.brave.Browser/config/source-brave-flags.conf ~/.var/app/com.brave.Browser/config/brave-flags.conf
      #    chmod 0444 ~/.var/app/com.brave.Browser/config/brave-flags.conf
      #  '';
      #};
    };

    environment.etc."brave/policies/managed/policy.json" = {
      text = ''
        {
          "BraveRewardsDisabled": true,
          "BraveWalletDisabled": true,
          "BraveVPNDisabled": true,
          "SyncDisabled": true,
          "TorDisabled": true,
          "BraveAIChatEnabled": false,
          "AutoFillEnabled": false,
          "AutofillCreditCardEnabled": false,
          "AutofillAddressEnabled": false,
          "PasswordManagerEnabled": false,
          "DefaultBrowserSettingEnabled": false,
          "PromotionalTabsEnabled": false,
          "PromotionsEnabled": false,
          "ImportAutofillFormData": false,
          "NewTabPageLocation": "https://glance.home.lab",
          "HomepageIsNewTabPage": true
        }
      '';
      mode = "0444";
    };
  };
}
