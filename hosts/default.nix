{ username, hostname, inputs, self, nixpkgs, ... }:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  lib = nixpkgs.lib;
  bootloader = ../modules/core/bootloader.nix;
  razer = ../modules/razer;
  nvidia = ../modules/nvidia;
  core = ../modules/core;
in
{
  nebula = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs username; };
    modules = [ (import ./nebula) ] ++
      [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = { inherit inputs username; };
            users.zaluru = (./home.nix);
          };
          nixpkgs = {
            overlays =
              [
                self.overlays.default
              ];
          };
        }
        core
        bootloader
        razer
        # nvidia # Curently broken
      ];
  };
  aurora = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs username; };
    modules = [ (import ./aurora) ] ++
      [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = { inherit inputs username; };
            users.zaluru = (./home.nix);
          };
          nixpkgs = {
            overlays =
              [
                self.overlays.default
              ];
          };
        }
        bootloader
      ];
  };
}
