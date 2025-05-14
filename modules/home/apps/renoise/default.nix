{ lib, config, pkgs, ... }:
let

  # TODO: Write a tutorial on how to fix the renoise audio issue when running it with pipewire
  # I just use the pipewire jack rather than pipewire alsa that is choosen by default by renoise
  # but after every rebuild it gets reset to use alsa 
  # so i had to set up qpwgraph and pin the pipewire connections for renoise, also autostart qpwgraph
  # it makes it so when i start renois it uses the pipewire jack and audio works without an issue
  # TODO: write a tutorial on how to setup renoise with the full paid version like here

  inherit (lib) mkIf types mkMerge mkOption mkEnableOption;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.renoise;

  releasesPath = "/opt/renoise";

  # Use 'nix-prefetch-url "file://path/to/file"' to determine the hash
  platforms = {
    x86_64-linux = {
      version = {
        "3.4.4" = {
          hash = "01drmbmqpc6dcar17gccxh2ksjgwb1vbxjlr5iq1cr6icahbq59n";
        };
      };
    };
    aarch64-linux = {
      version = {
        "3.4.4" = {
          hash = "0gndjlgdvxvrkjarybbxpc6zw07ihklpr1abxinmqi3g51lj0q0r";
        };
      };
    };
  };
in
{
  options.mine.apps.renoise = {
    enable = mkOpt types.bool false "Enable Renoise digital audio workstation.";
    full-version = mkOption {
      default = { };
      description = "Options for the full version of Renoise.";
      type = types.submodule {
        options = {
          enable = mkEnableOption "Use the full renoise version with the provided binary";
          version = mkOpt types.str "3.4.4" "Choose which version to use, defaults to 3.4.4";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home-manager.users.${user.name} = {
        home.packages = [ pkgs.renoise ];
      };

      systemd.tmpfiles.rules = [
        "d    ${releasesPath}    0755    root    root    -"
      ];
    })

    (mkIf cfg.full-version.enable {
      nixpkgs.overlays = [ (self: super: {
        renoise = super.renoise.override {
          releasePath = super.fetchurl {
            url = "file://${toString "${releasesPath}/rns_${builtins.replaceStrings [ "." ] [ "_" ] cfg.full-version.version}_${super.system}.tar.gz"}";
            sha256 = platforms.${super.system}.version.${cfg.full-version.version}.hash;
          };
        };
      }) ];
    })
  ];
}