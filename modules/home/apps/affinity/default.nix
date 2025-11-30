{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.affinity;

in
{
  options.mine.apps.affinity = {
    enable = mkOpt types.bool false "Affinity v3";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      home.packages = [
        inputs.affinity-nix.packages.x86_64-linux.v3
      ];
    };
  };
}
