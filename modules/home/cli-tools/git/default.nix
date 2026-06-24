{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.home-manager.git;

in
{
  options.mine.home-manager.git = {
    enable = mkEnableOption "Git configs";
  };

  config = mkIf cfg.enable {
    mine.cli-tools.git.enable = true;

    home-manager.users.${user.name} = {
      home.packages = with pkgs; [
        git
        gh
      ];
      programs = lib.mkMerge [
        {
          git = {
            enable = true;
            settings = {
              user = {
                name = "${user.name}";
                email = "${user.email}";
              };
              safe.directory = "*";
              init.defaultBranch = "main";
              pull.rebase = false;
              push.autoSetupRemote = true;
              core.editor = "nvim";
            };
          };
        }
        (lib.mkIf (user.shell.package == pkgs.fish) {
          fish.shellAliases = config.mine.defaults.aliases.git;
        })
      ];
    };
  };
}
