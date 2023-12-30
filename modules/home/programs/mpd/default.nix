{ pkgs
, ... }:

{
  services.mpd = {
    enable = true;
    network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "Pipewire mpd output"
      }
    '';
  };

  home.packages = with pkgs; [ mpc-cli ];
}
