{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib.zaluru) enabled;
  inherit (config.mine) user;

in
{
  imports = [
    ../../overlays/inputs
    (inputs.import-tree ../../modules)
    inputs.nix-private-config.nixosModules.configs
  ];

  config = {
    networking.hostName = "my-microvm";
    microvm = {
      hypervisor = "qemu";

      shares = [ {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      } ];
    };
  };
}