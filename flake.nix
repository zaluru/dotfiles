{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.37.1";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    astronvim = {
      url = "github:AstroNvim/AstroNvim/v3.40.3";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix/release-23.11";
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
            disko
            zjstatus
            nixos-wsl
            ;
        }
      );
      packages.x86_64-linux = {
        proxmox = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
          format = "proxmox";
        };
        aws = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
          format = "amazon";
        };
      };
    };
}
