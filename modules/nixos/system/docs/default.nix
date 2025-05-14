{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkIf mkForce;

in
{
  config = {
    documentation = {
      doc.enable = false;
      # Fish shell enables this and it takes forever to build man-cache as a result
      man.generateCaches = mkForce false;
    };
  };
}
