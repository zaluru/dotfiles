{ username
, hostname
, inputs
, self
, nixpkgs
, ... }:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
  };
  lib = nixpkgs.lib;
  # Nixos modules
  bootloader = ../modules/core/bootloader.nix;
  razer = ../modules/razer;
  nvidiaPrime = ../modules/nvidia;
  core = ../modules/core;
  virtualisation = ../modules/virtualisation;
  desktop = ../modules/desktop;
  # Home Manager modules - for desktop environments
  hyprland = ../modules/home/desktop/hyprland;
  qtile = ../modules/home/desktop/qtile;
in
{
  nebula = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs username; };
    modules = [ (import ./nebula) ] ++
      [
        {networking.hostName = "nebula";}
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = { inherit inputs username; };
            users.zaluru = {
              imports =
                  [ (import ./home-zaluru.nix)] ++
                  [ hyprland ];
            };
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
        virtualisation
        razer
        desktop
        # nvidiaPrime 
      ];
  };
  aurora = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs username; };
    modules = [ (import ./aurora) ] ++
      [
        {networking.hostName = "aurora";}
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = { inherit inputs username; };
            users.zaluru = {
              imports =
                  [ (import ./home-zaluru.nix)] ++
                  [ hyprland ];
            };
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
        virtualisation
        razer
        desktop
        nvidiaPrime
      ];
  };

  aurora-qtile = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs username; };
    modules = [ (import ./aurora) ] ++
      [
        {networking.hostName = "aurora";}
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = { inherit inputs username; };
            users.zaluru = {
            imports =
                [ (import ./home-zaluru.nix)] ++
                [ qtile ];
            };

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
        virtualisation
        razer
        desktop
        nvidiaPrime
      ];
  };
}
