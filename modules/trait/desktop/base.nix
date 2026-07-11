{ lib
, config
, pkgs
, inputs
, ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt enabled;
  inherit (config.mine) user;
  cfg = config.mine.trait.desktop.base;

in
{
  options.mine.trait.desktop.base = {
    enable = mkOpt types.bool false "Enabled trait - desktop.base";
  };

  config = mkIf cfg.enable {
    mine = {
      apps = {
        brave = enabled;
        discord = enabled;
        # TODO: very cool, browser profile in RAM: https://wiki.archlinux.org/title/Profile-sync-daemon
        firefox = enabled;
        gimp = enabled;
        inkscape = enabled;
        obsidian = enabled;
        thunderbird = enabled;
        signal-desktop = enabled;
        imv = enabled;
        alacritty = enabled;
        keepassxc = enabled;
        java-web-start = enabled;
        mpv = enabled;
        vscode = enabled;
        remmina = enabled;
      };

      cli-tools = {
        yt-dlp = enabled;
      };

      services = {
        mpd = enabled;
        kdeconnect = enabled;
        gpg-agent = enabled;
      };

      system = {
        audio = {
          pipewire = enabled;
          qpwgraph = enabled;
        };
        fonts = enabled;
      };
    };
  };
}