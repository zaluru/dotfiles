{
  lib,
  pkgs,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.system.virtual-display;

in
{
  options.mine.system.virtual-display = {
    enable = mkEnableOption "Enable virtual Display";
    # To find your gpu outputs identifiers run:
    # bash -c 'for p in /sys/class/drm/*/status; do echo "${p##*/card?-}: $(<"$p")"; done'
    output-id = mkOpt types.str "HDMI-A-2" "Enable virtual screen on specified gpu output";
    resolution = mkOpt types.str "1920x1080" "Specify resolution for the virtual display";
    refresh-rate = mkOpt types.int "60" "Specify refresh rate for the virtual display";
    edid = mkOpt types.str "virtualdisplay" "An EDID filename to be used for configured display";
  };

  config = mkIf cfg.enable {
    hardware.display = {
      outputs."${cfg.output-id}" = {
        edid = "${cfg.edid}.bin";
        mode = "${cfg.resolution}@${toString cfg.refresh-rate}e"; # You can verify if it was set properly with: cat /proc/cmdline
      };

      # To check the edid binary run
      # nix-shell -p v4l-utils.out --run "edid-decode /run/current-system/firmware/edid/virtualdisplay.bin"
      # Even if edid-decode outputs proper information, it might still not work with the kernel
      edid = {
        enable = true;
        packages = [
          # Inspired by: https://www.azdanov.dev/articles/2025/how-to-create-a-virtual-display-for-sunshine-on-arch-linux
          # Retrived from: https://git.linuxtv.org/v4l-utils.git/tree/utils/edid-decode/data
          # Coult also use linuxhw method like below, but this is more lean
          # Also the SAME030 from linuxhw result in - *ERROR* Invalid firmware EDID "edid/samsung.bin"
          (pkgs.runCommand "edid-custom" { } ''
            mkdir -p "$out/lib/firmware/edid"
            base64 -d > "$out/lib/firmware/edid/virtualdisplay.bin" <<'EOF'
            AP///////wBMLUBwAA4AAQEeAQOApV14Cqgzq1BFpScNSEi974BxT4HAgQCBgJUAqcCzANHACOgAMPJwWoCwWIoAUB10AAAeb8IAoKCgVVAwIDUAUB10AAAaAAAA/QAYeA//dwAKICAgICAgAAAA/ABTQU1TVU5HCiAgICAgAW4CA2fwXWEQHwQTBRQgISJdXl9gZWZiZD9AdXba28LDxMbHLAkHBxUHUFcHAGdUAIMBAADiAE/jBcMBbgMMAEAAmDwoAIABAgMEbdhdxAF4gFkCAADBNAvjBg0B5Q8B4PAf5QGLhJABb8IAoKCgVVAwIDUAUB10AAAaAAAAAAAAZw==
            EOF
          '')
        ];
        #        linuxhw = {
        #          samsung = [
        #            "Samsung"
        #            "SAME030"
        #            "Odyssey G80SD"
        #            "3840x2160"
        #            "31.5"
        #            "2024"
        #          ];
        #        };
      };
    };
  };
}
