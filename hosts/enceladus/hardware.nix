{ lib, ... }:

{
  hardware.pulseaudio.enable = lib.mkForce false; # Disable pulseaudio
  sound.enable = lib.mkForce false; # Disable alsa

  # Due to crackling i had to add more headroom on this host
  # journalctl --user-unit=pipewire --user-unit=wireplumber --user-unit=pipewire-pulse -f 
  services.pipewire.wireplumber.extraConfig.main."99-alsa-headroom" = ''
    alsa_monitor.rules = {
      matches = [
        {
          node.name = "~alsa_output.*"
        }
      ]
      actions = {
        update-props = {
          api.alsa.period-size   = 1024
          api.alsa.headroom      = 8192
        }
      }
    }
  '';
}
