{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.home-manager.ssh-config;
in
{
  options.mine.home-manager.ssh-config = {
    enable = mkEnableOption "SSH config";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {lib, ...}: {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
      };
      home = {
        file = {
          # home-manager wrongly thinks it doesn't manage (and thus shouldn't clobber) this file due to the activation script
          ".ssh/config".force = true;
        };

        activation = {
          # https://github.com/nix-community/home-manager/issues/322
          fixSshPermissions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            run install -d -m 0700 "$HOME/.ssh"
            if [ -L "$HOME/.ssh/config" ]; then
              src="$(readlink -f "$HOME/.ssh/config")"
              run rm -f "$HOME/.ssh/config"
              run install -m 0600 "$src" "$HOME/.ssh/config"
            fi
          '';
        };
      };
    };
  };
}
