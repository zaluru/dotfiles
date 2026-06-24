{
  lib,
  config,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.kdeconnect;

in
{
  options.mine.services.kdeconnect = {
    enable = mkEnableOption "Enable kdeconnect user service.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.kdeconnect.enable = true;
    };

    networking.firewall = rec {
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };
}