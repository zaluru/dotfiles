{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.system.audio.musnix;

in
{
  options.mine.system.audio.musnix = {
    enable = mkEnableOption "Enable musnix - real time audio optimizations.";
  };

  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  config = mkIf cfg.enable {
    musnix.enable = true;
    users.users.${user.name}.extraGroups = [ "audio" ];
  };
}