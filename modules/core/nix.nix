{ lib, inputs, ... }:

{
  environment = {
    defaultPackages = [ ];
  };

  nixpkgs = {
    config = {
      allowUnfree = false;
      allowBroken = true;
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "steam-run"
          "steam"
          "steam-original"
          "nvidia-x11"
          "nvidia-settings"
          "davinci-resolve"
          "reaper"
          "rider"
          "phpstorm"
          "datagrip"
          "nvidia-persistenced"
          "itch"
          "renoise"
          "discord"
        ];
    };
    overlays = [
      (import ../../overlays/mutt-wizard)
      (final: prev: {
        plasmusic-toolbar = (import inputs.nixpkgs-unstable { system = final.system; }).plasmusic-toolbar;
      })
      (final: prev: {
        application-title-bar =
          (import inputs.nixpkgs-unstable { system = final.system; }).application-title-bar;
      })
    ];
  };

  # faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    # TODO have to learn how this works exactly
    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: { flake = v; }) inputs;

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    settings = {
      auto-optimise-store = true;
      # allow sudo users to mark the following values as trusted
      allowed-users = [ "@wheel" ];
      # only allow sudo users to manage the nix store
      trusted-users = [ "@wheel" ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # use binary cache
      builders-use-substitutes = true;
      substituters = [
        "https://cache.nixos.org"
        "https://fortuneteller2k.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      ];
    };
  };
}
