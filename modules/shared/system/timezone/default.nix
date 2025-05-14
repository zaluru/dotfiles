{ lib, config, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  cfg = config.mine.system.timezone;

in
{
  options.mine.system.timezone = {
    enable = mkOpt types.bool true "Enable time";
    location = mkOpt types.str "Europe/Warsaw" "Timezone Location";
  };

  config = mkIf cfg.enable {
    time.timeZone = "${cfg.location}";
  };
}
