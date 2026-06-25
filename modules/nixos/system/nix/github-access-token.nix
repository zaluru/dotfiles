{ lib, config, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.system.nix.github-access-token;

in
{
  options.mine.system.nix.github-access-token = {
    enable = mkEnableOption "github access token for nix";
  };

  config = mkIf cfg.enable {

    nix.extraOptions = ''
      !include ${config.sops.templates."nix-github-access-token.conf".path}
    '';

    sops.templates."nix-github-access-token.conf" = {
      content = ''
        access-tokens = github.com=${config.sops.placeholder.github-access-token}
      '';
      owner = "${user.name}";
      mode = "0440";
    };

    sops.secrets."github-access-token" = {
    };
  };
}
