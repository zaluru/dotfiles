{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url  = "github:nix-community/emacs-overlay";
    stylix.url = "github:danth/stylix";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {self, nixpkgs, ... }@inputs:
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
    };
}
