{ username
, hostname
, inputs
, self
, nixpkgs
, astronvim
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
  server = ../modules/server;
  # Home Manager modules - for desktop environments
  hyprland = ../modules/home/desktop/hyprland;
  gnome = ../modules/home/desktop/gnome;
  qtile = ../modules/home/desktop/qtile;
  agenix = inputs.agenix.nixosModules.default;
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
            extraSpecialArgs = { inherit inputs username astronvim; };
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
        gnome
        server
	# Secrets management
	agenix
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
            extraSpecialArgs = { inherit inputs username astronvim; };
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
	      # Secrets management
	      agenix
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
	      # Secrets management
	      agenix
      ];
  };
}
