{ lib
, config
, pkgs
, inputs
, ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt enabled;
  inherit (config.mine) user;
  cfg = config.mine.trait.base;

in
{
  options.mine.trait.base = {
    enable = mkOpt types.bool false "Enabled trait - base";
  };

  config = mkIf cfg.enable {
    mine = {

      user = {
        enable = true;
        home-manager = enabled;
        shell.package = pkgs.fish;
        xdg-default-dirs = enabled;
      };
      services = {
        netbird.client.main = enabled;
        cockpit = enabled;
        beszel.agent = enabled;
        kanidm.client = enabled;
        ssh-agent = enabled;
      };


      system = {
        networking = {
          firewall = enabled;
        };
        nix = {
          unfree = enabled;
          flakes = enabled;
        };
        services = {
          openssh = enabled;
        };
        defaultLocales = enabled;
      };
    };
  };
};