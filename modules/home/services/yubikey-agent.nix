{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine) user;
  cfg = config.mine.services.yubikey-agent;

in
{
  options.mine.services.yubikey-agent = {
    enable = mkEnableOption "Enable yubikey-agent";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      services.yubikey-agent.enable = true;

      # TODO: Default initialization for fish fails, below works
      sshAuthSock.initialization.fish = lib.mkForce ''
        if set -q XDG_RUNTIME_DIR
            set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
        else
            set -x SSH_AUTH_SOCK "/run/user/$UID/yubikey-agent/yubikey-agent.sock"
        end
      '';
    };
  };
}
