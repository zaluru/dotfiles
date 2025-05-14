{
  inputs,
  lib,
  config,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.nix.flakes;

in
{
  options.mine.system.nix.flakes = {
    enable = mkEnableOption "Enable Flakes";
  };

  config = mkIf cfg.enable {
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # TODO have to learn how this works exactly
      # pin the registry to avoid downloading and evaling a new nixpkgs version every time
      registry = lib.mapAttrs (_: v: { flake = v; }) inputs;

      nixPath = [
        "nixpkgs=${inputs.nixpkgs.outPath}"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];

      # TODO: this might be also usefull
      # https://discourse.nixos.org/t/problems-after-switching-to-flake-system/24093/8
      #registry.nixpkgs.flake = inputs.nixpkgs;
      #nixPath = [ "/etc/nix/path" ];

      extraOptions = ''
        warn-dirty = false
      '';
    };
    environment.etc."nix/path/nixpkgs".source = inputs.nixpkgs;
  };
}
