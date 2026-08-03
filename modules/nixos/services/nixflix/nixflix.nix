{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.services.nixflix;

in
{
  options.mine.services.nixflix = {
    enable = mkOpt types.bool false "nixflix";
  };

  imports = [
    inputs.nixflix.nixosModules.default
  ];

  config = mkIf cfg.enable {

    # https://github.com/kiriwalawren/dotnix/tree/main/modules/server/nixflix
    sops.secrets = {
      "qbittorrent/password" = { };
      "sonarr/api_key" = { };
      "sonarr/password" = { };
      "radarr/api_key" = { };
      "radarr/password" = { };
      "prowlarr/api_key" = { };
      "prowlarr/password" = { };
      "jellyfin/admin_password" = { };
      "jellyfin/api_key" = { };
      "sabnzbd/api_key" = { };
      "wireguard/arr/config" = { };
    };

    nixflix = {
      enable = true;
      mediaDir = "/data/storage-nvme-0/nixflix/media";
      stateDir = "/data/storage-nvme-0/nixflix/.state";

      caddy = {
        enable = true;
        tls.enable = true; 
        domain = "arr.zaluru.com";
      };

      postgres.enable = true;

      torrentClients.qbittorrent = {
        enable = true;
        subdomain = "torrent";
        password._secret = config.sops.secrets."qbittorrent/password".path;
        vpn.enable = true;
        serverConfig = {
          LegalNotice.Accepted = true;
          BitTorrent = {
            Session = {
              AddTorrentStopped = false;
              Port = 40040;
              QueueingSystemEnabled = true;
              #SSL.Port = 32380;
              # required for port forwarding from a VPN
              ReannounceWhenAddressChanged = true;
            };
          };
          Preferences = {
            WebUI = {
              Username = "${config.nix-private.nixflix.qbittorrent.Username}";
              Password_PBKDF2 = "${config.nix-private.nixflix.qbittorrent.Password_PBKDF2}"; 
              #Address = "127.0.0.1";
            };
            General.Locale = "en";
          };
        };
      };

      sonarr = {
        enable = true;
        config = {
          apiKey = {
            _secret = config.sops.secrets."sonarr/api_key".path;
          };
          hostConfig.password = {
            _secret = config.sops.secrets."sonarr/password".path;
          };
        };
      };

      radarr = {
        enable = true;
        config = {
          apiKey = {
            _secret = config.sops.secrets."radarr/api_key".path;
          };
          hostConfig.password = {
            _secret = config.sops.secrets."radarr/password".path;
          };
        };
      };

      prowlarr = {
        enable = true;
        config = {
          apiKey = {
            _secret = config.sops.secrets."prowlarr/api_key".path;
          };
          hostConfig.password = {
            _secret = config.sops.secrets."prowlarr/password".path;
          };
        };
      };
/*
      sabnzbd = {
        enable = true;
        settings = {
          misc.api_key = {
            _secret = config.sops.secrets."sabnzbd/api_key".path;
          };
        };
      };
*/
      jellyfin = {
        enable = true;
        apiKey._secret = config.sops.secrets."jellyfin/api_key".path;
        users.admin = {
          policy.isAdministrator = true;
          password = {
            _secret = config.sops.secrets."jellyfin/admin_password".path;
          };
        };
      };

      vpn = {
        enable = true;
        wgConfFile = config.sops.secrets."wireguard/arr/config".path;
      };

    };
  };
}
