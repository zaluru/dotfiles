{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.container.quadlet-nix;

in
{

  imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

  options.mine.container.quadlet-nix = {
    enable = mkOpt types.bool false "quadlet-nix: Manages Podman containers, networks, pods, etc. on NixOS via Quadlet.";
  };

  config = mkIf cfg.enable {
    home-manager.sharedModules = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    users.users.${user.name} = {
      extraGroups = [
        "podman"
      ];
    };
  };
}
