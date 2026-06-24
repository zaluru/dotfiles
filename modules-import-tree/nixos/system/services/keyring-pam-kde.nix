{ pkgs, lib, config, ... }:
let

  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.mine.system.services.keyring-pam-kde;

  myOverlay = final: prev: {
    kwallet = pkgs.unstable.kwallet;
  };

in
{
  options.mine.system.services.keyring-pam-kde = {
    enable = mkEnableOption "Enable KDE keyring pam service";
  };

# TODO: does not seem to be working :|
  config = mkIf cfg.enable {
    nixpkgs.overlays = [ myOverlay ];

    security.pam.services.login.kwallet = {
      enable = true;
      package = mkForce pkgs.kdePackages.kwallet-pam;
    };

    security.pam.services.gdm-password.kwallet = {
      enable = true;
      package = mkForce pkgs.kdePackages.kwallet-pam;
    };
  };
}
