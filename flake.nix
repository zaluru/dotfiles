{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      astronvim,
      disko,
      nixos-generators,
      zjstatus,
      nixos-wsl,
      hyprland,
      plasma-manager,
      nix-flatpak,
      klogg,
      ghostty,
      ...
    }@inputs:
    let
      username = "zaluru";
      selfPkgs = import ./pkgs;

      pkgsForSystem = system: import nixpkgs { inherit system; };

      # TODO: fix this mess up so that i do not have to hard code the system
      system = "x86_64-linux";
      # For some reason setting this makes the configuration for nixpkgs on modules/core/nix be ignored
      #pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

      allVMs = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllVMs =
        f:
        nixpkgs.lib.genAttrs allVMs (
          system:
          f {
            inherit system;
            pkgs = pkgsForSystem system;
          }
        );
    in
    {
      overlays.default = selfPkgs.overlay;
      nixosConfigurations = (
        import ./hosts {
          inherit
            self
            inputs
            nixpkgs
            nixpkgs-unstable
            username
            astronvim
            hyprland
            plasma-manager
            nix-flatpak
            klogg
            disko
            zjstatus
            nixos-wsl
            pkgs-unstable
            ;
        }
      );
      packages = forAllVMs (
        { system, pkgs }:
        {
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
                plasma-manager
                nix-flatpak
                klogg
                disko
                zjstatus
                nixos-wsl
                ;
            };
            modules =
              [ (import ./hosts/phobos) ]
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
        }
      );
    };
}
