{ inputs, ... }:
let
  unstablePkgs = final: prev: {
    unstable = import inputs.unstable {
      system = "${prev.system}";
      config.allowUnfree = true;
    };
  };

  davinciResolvePkgs = final: prev: {
    davinci-resolve-pkgs = import inputs.davinci-resolve-pkgs {
      system = "${prev.system}";
      config.allowUnfree = true;
    };
  };
in
{
  nixpkgs.overlays = [ unstablePkgs davinciResolvePkgs ];
}
