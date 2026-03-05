{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.pelican-wings;

in
{
  options.mine.services.pelican-wings = {
    enable = mkOpt types.bool false "Wings - Pelican server control plane.";
  };

  imports = [
    inputs.pelican-wings.nixosModules.default
  ];

  config = mkIf cfg.enable {
    services.pterodactyl.wings.enable = true;
  };
}
