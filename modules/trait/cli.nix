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
  cfg = config.mine.trait.cli;

in
{
  options.mine.trait.cli = {
    enable = mkOpt types.bool false "Enabled trait - cli";
  };

  config = mkIf cfg.enable {
    mine = {
      home-manager = {
        git = enabled;
        zoxide = enabled;
        atuin = enabled;
        fzf = enabled;
        ssh-config = enabled;
      };

      cli-tools = {
        direnv = enabled;
        just = enabled;
        btop = enabled;
        lsof = enabled;
      };
    };
  };
}
