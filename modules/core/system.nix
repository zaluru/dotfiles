{ pkgs, ... }:

{

  time = {
    timeZone = "Europe/Warsaw";
    hardwareClockInLocalTime = true;
  };

  i18n =
    let
      defaultLocale = "en_US.UTF-8";
      pl = "pl_PL.UTF-8";
    in
    {
      inherit defaultLocale;
      extraLocaleSettings = {
        LANG = defaultLocale;
        LC_COLLATE = defaultLocale;
        LC_CTYPE = defaultLocale;
        LC_MESSAGES = defaultLocale;

        LC_ADDRESS = pl;
        LC_IDENTIFICATION = pl;
        LC_MEASUREMENT = pl;
        LC_MONETARY = pl;
        LC_NAME = pl;
        LC_NUMERIC = pl;
        LC_PAPER = pl;
        LC_TELEPHONE = pl;
        LC_TIME = pl;
      };
    };

  systemd =
    let
      extraConfig = ''
        DefaultTimeoutStopSec=15s
      '';
    in
    {
      inherit extraConfig;
      user = {
        inherit extraConfig;
      };

      # Systemd OOMd
      # Fedora enables these options by default. See the 10-oomd-* files here:
      # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
      oomd = {
        enableRootSlice = true;
        enableUserServices = true;
      };
    };
  environment.systemPackages = with pkgs; [ killall ];
  programs = {
    steam.enable = true;

    # allow users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;
    adb.enable = true;
  };

  environment.localBinInPath = true;
}
