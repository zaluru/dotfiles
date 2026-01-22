{ inputs, ... }:
let
  unstablePkgs = final: prev: {
    unstable = import inputs.unstable {
      inherit (final) config;
      inherit (final.stdenv.hostPlatform) system;
    };
  };

  davinciResolvePkgs = final: prev: {
    davinci-resolve-pkgs = import inputs.davinci-resolve-pkgs {
      inherit (final) config;
      inherit (final.stdenv.hostPlatform) system;
    };
  };

  winappsPkgs = final: prev: {
    winapps = import inputs.winapps {
      inherit (final) config;
      inherit (final.stdenv.hostPlatform) system;
    };
  };
in
{
  nixpkgs.overlays = [ unstablePkgs davinciResolvePkgs winappsPkgs ];
}
