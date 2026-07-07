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
  cfg = config.mine.trait.secrets.sops;

in
{
  options.mine.trait.secrets.sops = {
    enable = mkOpt types.bool false "Enabled trait - secrets.sops";
  };

  config = mkIf cfg.enable {
    mine = {
      cli-tools = {
        age = enabled;
        sops-nix = {
          enable = true;
          ageKeyFile.path = "/home/zaluru/.config/sops/age/keys.txt";
          defaultSopsFile = inputs.nix-private-config.packages.${pkgs.stdenv.hostPlatform.system}.mySecrets + "/encrypted/${config.mine.system.networking.networkmanager.hostname}.yaml";
        };
      };
    };
  };
}
