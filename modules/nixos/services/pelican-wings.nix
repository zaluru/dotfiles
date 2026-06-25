{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
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
    networking.firewall.allowedTCPPorts = [
      2022
      9999
    ]; # Have to open the sftp and api port of wings
    systemd.services.wings.environment.TZ = "Etc/UTC"; # TODO: wings won't start without that
    nixpkgs.overlays = [ inputs.pelican-wings.overlays.default ];
    services.pelican.wings = {
      enable = true;
      extraConfigFile = builtins.toFile "config.yaml" "";
    };
  };
}
