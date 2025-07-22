{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    agenix.url = "github:ryantm/agenix";
    musnix.url = "github:musnix/musnix";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus = {
      url = "github:dj95/zjstatus/v0.20.2";
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
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinned packages
    # You can find the nixpkgs reference easly at https://www.nixhub.io/
    davinci-resolve-pkgs.url = "github:nixos/nixpkgs/a16efe5d2fc7455d7328a01f4692bfec152965b3"; # version 19.1.4
  };

  outputs =
    {
      self,
      nixpkgs,
      unstable,
      home-manager,
      hyprland,
      plasma-manager,
      emacs-overlay,
      nix-flatpak,
      astronvim,
      stylix,
      agenix,
      disko,
      nixos-generators,
      zjstatus,
      nixos-wsl,
      nix-index-database,
      nixvim,
      sops-nix,
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
          ];
        };
      };
      packages = forEachSupportedSystem (
        { pkgs }:
        {
          klassy-qt6 = pkgs.kdePackages.callPackage ./packages/klassy-qt6.nix { };
          iso = nixos-generators.nixosGenerate {
            specialArgs = {
              inherit inputs;
              inherit lib;
            };
            system = "x86_64-linux";
            format = "iso";
            modules = [
              ./systems/x86_64-iso-work-laptop/configuration.nix
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