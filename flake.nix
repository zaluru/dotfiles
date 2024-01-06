{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url  = "github:nix-community/emacs-overlay";
    astronvim = {
      url = "github:AstroNvim/AstroNvim/v3.40.3";
      flake = false;
    };
    stylix.url = "github:danth/stylix";
    agenix.url = "github:ryantm/agenix";

    nix-on-droid = {
      url = "github:t184256/nix-on-droid/testing";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    disko = {
      url = "github:nix-community/disko"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, nix-on-droid, astronvim, disko, ... }@inputs:
    let
      username = "zaluru";
      hostname = "andromeda";
      selfPkgs = import ./pkgs;
    in
    {
      overlays.default = selfPkgs.overlay;
      nixosConfigurations = (
        import ./hosts {
          inherit self inputs nixpkgs username hostname astronvim disko;
        }
      );
      nixOnDroidConfigurations = {
        luna = nix-on-droid.lib.nixOnDroidConfiguration {
	  modules = [ ./hosts/luna/nix-on-droid.nix ];
	  extraSpecialArgs = {
            inherit self inputs nixpkgs username hostname astronvim;
	  };
	  pkgs = import nixpkgs {
            system = "aarch64-linux";
	  };
	};
      };
    };
}
