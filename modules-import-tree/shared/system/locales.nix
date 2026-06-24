{ lib, config, pkgs, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.system.defaultLocales;

in
{
  options.mine.system.defaultLocales = {
    enable = mkEnableOption "Setup default english locales with polish support.";
  };
  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "en_US.UTF-8";

      supportedLocales = ["en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" "C.UTF-8/UTF-8"];

      extraLocaleSettings = {
        LC_CTYPE = "pl_PL.UTF8";
        LC_ADDRESS = "pl_PL.UTF8";
        LC_MEASUREMENT = "pl_PL.UTF8";
        LC_MESSAGES = "en_US.UTF-8";
        LC_MONETARY = "pl_PL.UTF8";
        LC_NAME = "pl_PL.UTF8";
        LC_NUMERIC = "pl_PL.UTF8";
        LC_PAPER = "pl_PL.UTF8";
        LC_TELEPHONE = "pl_PL.UTF8";
        LC_TIME = "pl_PL.UTF8";
        LC_COLLATE = "pl_PL.UTF8";
      };
    };
  };
}