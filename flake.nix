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

    disko = {
      url = "github:nix-community/disko"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, astronvim, disko, ... }@inputs:
    let
      username = "zaluru";
      selfPkgs = import ./pkgs;
    in
    {
      overlays.default = selfPkgs.overlay;
      nixosConfigurations = (
        import ./hosts {
          inherit self inputs nixpkgs username hostname astronvim disko;
        }
      );
    };
}
