{
  username,
  inputs,
  self,
  nixpkgs,
  astronvim,
  hyprland,
  disko,
  nixos-wsl,
  ...
}:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
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
  hyprland-system = ../modules/home/desktop/hyprland; # need to change this to a configuration option or something
  gnome = ../modules/home/desktop/gnome;
  qtile = ../modules/home/desktop/qtile;
  agenix = inputs.agenix.nixosModules.default;
  wsl = ../modules/core/wsl.nix;
in
{
  nebula = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self inputs username;
    };
    modules =
      [ (import ./nebula) ]
      ++ [
        { networking.hostName = "nebula"; }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit
                inputs
                username
                astronvim
                hyprland
                ;
            };
            users.zaluru = {
              imports = [ (import ./home-zaluru.nix) ] ++ [ hyprland-system ];
            };
          };
          nixpkgs = {
            overlays = [ self.overlays.default ];
          };
        }
        core
        bootloader
        virtualisation
        razer
        desktop
        #gnome
        server
        # Secrets management
        agenix
        # nvidiaPrime 
      ];
  };
  aurora = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self inputs username;
    };
    modules =
      [ (import ./aurora) ]
      ++ [
        { networking.hostName = "aurora"; }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit
                inputs
                username
                astronvim
                hyprland
                ;
            };
            users.zaluru = {
              imports = [ (import ./home-zaluru.nix) ] ++ [ hyprland-system ];
            };
          };
          nixpkgs = {
            overlays = [ self.overlays.default ];
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
    specialArgs = {
      inherit self inputs username;
    };
    modules =
      [ (import ./aurora) ]
      ++ [
        { networking.hostName = "aurora"; }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs username;
            };
            users.zaluru = {
              imports = [ (import ./home-zaluru.nix) ] ++ [ qtile ];
            };
          };
          nixpkgs = {
            overlays = [ self.overlays.default ];
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
  europa = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = {
      inherit self inputs username;
    };
    modules =
      [ (import ./europa) ]
      ++ [
        { networking.hostName = "europa"; }
        core
        server
        disko.nixosModules.disko
        agenix
      ];
  };
  proteus = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = {
      inherit self inputs username;
    };
    modules =
      [ (import ./proteus) ]
      ++ [
        { networking.hostName = "proteus"; }
        core
        bootloader
        virtualisation
        server
        agenix
      ];
  };
  phobos = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        self
        inputs
        username
        nixos-wsl
        ;
    };
    modules =
      [ (import ./phobos) ]
      ++ [
        { networking.hostName = "phobos"; }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit inputs username astronvim;
            };
            users.zaluru = {
              imports = [ (import ./home-zaluru.nix) ];
            };
          };
          nixpkgs = {
            overlays = [ self.overlays.default ];
          };
        }
        wsl
        core
        virtualisation
        # Secrets management
        agenix
      ];
  };
}
