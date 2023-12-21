{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url  = "github:nix-community/emacs-overlay";
    stylix.url = "github:danth/stylix";
    agenix.url = "github:ryantm/agenix";

    nix-on-droid = {
      url = "github:t184256/nix-on-droid/testing";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {self, nixpkgs, nix-on-droid, ... }@inputs:
    let
      username = "zaluru";
      hostname = "andromeda";
      selfPkgs = import ./pkgs;
    in
    {
      overlays.default = selfPkgs.overlay;
      nixosConfigurations = (
        import ./hosts {
          inherit self inputs nixpkgs username hostname;
        }
      );
      nixOnDroidConfigurations = {
        luna = nix-on-droid.lib.nixOnDroidConfiguration {
	  modules = [ ./hosts/luna/nix-on-droid.nix ];
	  pkgs = import nixpkgs {
            system = "aarch64-linux";
	  };
	};
      };
    };
}
