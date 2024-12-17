{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.40.0";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    astronvim = {
      url = "github:AstroNvim/AstroNvim/v3.40.3";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    agenix.url = "github:ryantm/agenix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      astronvim,
      disko,
      nixos-generators,
      zjstatus,
      nixos-wsl,
      hyprland,
      ...
    }@inputs:
    let
      username = "zaluru";
      selfPkgs = import ./pkgs;

      pkgsForSystem = system: import nixpkgs {
        inherit system;
      };
      allVMs = [ "x86_64-linux" "aarch64-linux" ];
      forAllVMs = f: nixpkgs.lib.genAttrs allVMs (system: f {
        inherit system;
        pkgs = pkgsForSystem system;
      });
    in
    {
      overlays.default = selfPkgs.overlay;
      nixosConfigurations = (
        import ./hosts {
          inherit
            self
            inputs
            nixpkgs
            username
            astronvim
            hyprland
            plasma-manager
            nix-flatpak
            disko
            zjstatus
            nixos-wsl
            ;
        }
      );
      packages = forAllVMs ({ system, pkgs }: {
        vm = nixos-generators.nixosGenerate {
          system = system;
          specialArgs = {
            diskSize = 50 * 1024;
            inherit
              system
              self
              inputs
              nixpkgs
              username
              astronvim
              hyprland
              disko
              zjstatus
              nixos-wsl;
                plasma-manager
                nix-flatpak
          };
          modules = [ (import ./hosts/phobos) ]
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
                  imports = [ (import ./hosts/home-zaluru.nix) ];
                };
              };
              nixpkgs = {
                overlays = [ self.overlays.default ];
              };
            }
            ./modules/core
            ./modules/virtualisation
            # Secrets management
            inputs.agenix.nixosModules.default
          ];
          format = "qcow";
        };
      });
    };
}
