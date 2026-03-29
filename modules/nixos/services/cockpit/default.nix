{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.cockpit;

in
{
  options.mine.services.cockpit = {
    enable = mkEnableOption "Enable Cockpit.";
  };

  # cockpit service in 25.11 dose not have the plugins option
  disabledModules = [
    "services/monitoring/cockpit.nix"
  ];

  imports = [
    "${inputs.unstable}/nixos/modules/services/monitoring/cockpit.nix"
  ];

  config = mkIf cfg.enable {
    services.cockpit = {
      enable = true;
      package = pkgs.unstable.cockpit;
      plugins = [
        pkgs.unstable.cockpit-podman
        pkgs.unstable.cockpit-machines
        pkgs.unstable.cockpit-files
      ];
      allowed-origins = [
        "http://localhost:9090"
      ];
    };
  };
}