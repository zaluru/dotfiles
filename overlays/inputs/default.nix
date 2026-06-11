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

  # less disk usage, as input used 331 M, as overlay with sparseCheckout 46M
  dashboardIconsSvg = final: prev: {
    dashboard-icons-svg = prev.runCommand "dashboard-icons-svg" {} ''
      cp -r ${prev.fetchgit {
      name = "dashboard-icons-svg";
      url = "https://github.com/homarr-labs/dashboard-icons";
      rev = "0f2fc5a515ede104e640da39e5c185d5c1ae9d84";
      sparseCheckout = [ "svg" ];
      hash = "sha256-uR4LVPznWCH50dAANaqPzkZqK8lqt7koXJbZTeRiM5g=";
      }}/svg $out
    '';
  };

in
{
  nixpkgs.overlays = [ unstablePkgs davinciResolvePkgs dashboardIconsSvg ];
}
