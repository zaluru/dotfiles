{ lib, config, pkgs, inputs, ... }:
let

  inherit (lib) mkIf types mkForce;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.forgejo;

in
{
  options.mine.services.forgejo = {
    enable = mkOpt types.bool false "Forgejo - git forge";
  };

  config = mkIf cfg.enable {

    services.caddy.virtualHosts."git.i.zaluru.com".extraConfig = ''
      request_body {
        max_size 512MB
      }

      reverse_proxy localhost:3000
    '';

    services.openssh.settings.AcceptEnv = mkForce [ "GIT_PROTOCOL" ]; # TODO: Conflicts with proxmox, set temporarly for testing 

    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      # https://forgejo.org/docs/latest/admin/config-cheat-sheet/
      settings = {
        server = {
          DOMAIN = "git.i.zaluru.com";
          #SSH_PORT = lib.head config.services.openssh.ports;
          # https://github.com/NixOS/nixpkgs/issues/306205
          START_SSH_SERVER = true;
          DISABLE_SSH = true;
          ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}/"; 
          HTTP_PORT = 3000;
        };
        service = {
          DISABLE_REGISTRATION = false; 
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true; # so only users from kanidm can register
          ENABLE_INTERNAL_SIGNIN = false;
          ENABLE_BASIC_AUTHENTICATION = false;
        };
        openid = {
          ENABLE_OPENID_SIGNIN = false;
        };
      };
    };

    sops.secrets.forgejo-admin-password.owner = "forgejo";
    systemd.services.forgejo.preStart = let 
      adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
      pwd = config.sops.secrets.forgejo-admin-password;
      user = "admin-zaluru"; # Forgejo doesn't allow creation of an account named "admin"
    in ''
      ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';

    environment.systemPackages = [ pkgs.forgejo-cli ];
  };
}
