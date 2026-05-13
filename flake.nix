{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    musnix.url = "github:musnix/musnix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #affinity-nix.url = "github:mrshmllow/affinity-nix";
    pelican-wings.url = "https://codeberg.org/zaluru/pelican-wings-flake/archive/master.tar.gz";

    nix-private-config = {
      url = "git+ssh://git@codeberg.org/zaluru/nix-private-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "https://github.com/hyprwm/Hyprland";
      type = "git";
      ref = "refs/tags/v0.46.0";
      submodules = true;
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    astronvim = {
      url = "github:AstroNvim/AstroNvim/v3.40.3";
      flake = false;
    };

#    stylix = {
#      url = "github:danth/stylix";
#      inputs = {
#        nixpkgs.follows = "nixpkgs";
#     };
#   };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus = {
      url = "github:dj95/zjstatus/v0.22.0";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS/ca0970551a092fd69fdbb31ef3ea2dfe15f96349";
    };

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    #vicinae.url = "github:vicinaehq/vicinae/v0.9.6";

    # Pinned packages
    # You can find the nixpkgs reference easly at https://www.nixhub.io/
    davinci-resolve-pkgs.url = "github:nixos/nixpkgs/6368eda62c9775c38ef7f714b2555a741c20c72d"; # version 20.3.2
  };

  outputs =
    {
      self,
      nixpkgs,
      unstable,
      home-manager,
      nix-private-config,
      hyprland,
      plasma-manager,
      nix-flatpak,
      astronvim,
      #stylix,
      disko,
      nixos-generators,
      zjstatus,
      nixos-wsl,
      nix-index-database,
      nixvim,
      sops-nix,
      nixarr,
      nixos-hardware,
      #vicinae,
      #affinity-nix,
      jovian,
      pelican-wings,
      quadlet-nix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (
        self: super: {
          zaluru = import ./lib {
            inherit inputs;
            lib = self;
          };
        }
      );
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      nixosConfigurations = {
        "nebula" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit lib;
          };
          modules = [
            ./hosts/nebula/configuration.nix
            nix-index-database.nixosModules.nix-index
            disko.nixosModules.disko
          ];
        };
        "quasar" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit lib;
          };
          modules = [
            ./hosts/quasar/configuration.nix
            nix-index-database.nixosModules.nix-index
            disko.nixosModules.disko
          ];
        };
        "blazar" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit lib;
          };
          modules = [
            ./hosts/blazar/configuration.nix
            nix-index-database.nixosModules.nix-index
            disko.nixosModules.disko
          ];
        };
        "proteus" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit lib;
          };
          modules = [
            ./hosts/nebula/configuration.nix
            nix-index-database.nixosModules.nix-index
            disko.nixosModules.disko
          ];
        };
        "work-laptop" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit lib;
          };
          modules = [
            ./hosts/work-laptop/configuration.nix
            nix-index-database.nixosModules.nix-index
            disko.nixosModules.disko
            nixos-hardware.nixosModules.dell-latitude-e7240
          ];
        };
      };
      packages = forEachSupportedSystem (
        { pkgs }:
        {
          iso = nixos-generators.nixosGenerate {
            specialArgs = {
              inherit inputs;
              inherit lib;
            };
            system = "x86_64-linux";
            format = "iso";
            modules = [
              ./systems/x86_64-iso/default.nix
              nix-index-database.nixosModules.nix-index
              disko.nixosModules.disko
            ];
          };
          vm-nogui = nixos-generators.nixosGenerate {
            specialArgs = {
              inherit inputs;
              inherit lib;
            };
            system = "x86_64-linux";
            format = "vm-nogui";
            modules = [
              ./systems/x86_64-vm-nogui
              nix-index-database.nixosModules.nix-index
            ];
          };
        }
      );

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          tf =
            with pkgs;
            mkShell {
              buildInputs = [
                opentofu
                awscli2
              ];
            };
          python =
            with pkgs;
            mkShell {
              buildInputs = [
                python312Full
                (python312.withPackages (
                  ps:
                  with ps;
                  with python312Packages;
                  [
                    requests
                  ]
                ))
              ];
            };
        }
      );
    };
}