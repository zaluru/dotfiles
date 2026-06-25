{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.ente;

in
{
  options.mine.services.ente = {
    enable = mkEnableOption "Enable Ente. WIP!";
  };

  config = mkIf cfg.enable {

    # TODO: Not yet completed

    services.ente = {
      web = {
        enable = true;
        domains = {
          accounts = "accounts.e.zaluru.com";
          albums = "albums.e.zaluru.com";
          cast = "cast.e.zaluru.com";
          photos = "photos.e.zaluru.com";
        };
      };
      api = {
        enable = true;
        nginx.enable = false;
        enableLocalDB = true;
        domain = "api.e.zaluru.com";
        settings = {
          apps = {
            accounts = "https://accounts.e.zaluru.com";
            cast = "https://cast.e.zaluru.com";
            public-albums = "https://albums.e.zaluru.com";
          };
          s3 = {
            use_path_style_urls = true;
            b2-eu-cen = {
              endpoint._secret = config.sops.secrets."ente-s3-endpoint".path;
              # Must be us-east-1 as it is required internally by ente
              region = "us-east-1";
              bucket._secret = config.sops.secrets."ente-s3-bucket".path;
              key._secret = config.sops.secrets."ente-s3-key".path;
              secret._secret = config.sops.secrets."ente-s3-secret".path;
            };
          };
          key = {
            # generate with: openssl rand -base64 32
            encryption._secret = config.sops.secrets."ente-encryption-key".path;
            # generate with: openssl rand -base64 64
            hash._secret = config.sops.secrets."ente-hash-key".path;
          };
          # generate with: openssl rand -base64 32
          jwt.secret._secret = config.sops.secrets."ente-jwt-secret".path;
        };
      };
    };

    services.caddy.virtualHosts."accounts.e.zaluru.com".extraConfig = ''
      reverse_proxy http://127.0.0.1:8080 {
        header_down X-Real-IP {http.request.remote}
        header_down X-Forwarded-For {http.request.remote}
      }
    '';
    services.caddy.virtualHosts."albums.e.zaluru.com".extraConfig = ''
      reverse_proxy http://127.0.0.1:8080 {
        header_down X-Real-IP {http.request.remote}
        header_down X-Forwarded-For {http.request.remote}
      }
    '';
    services.caddy.virtualHosts."cast.e.zaluru.com".extraConfig = ''
      reverse_proxy http://127.0.0.1:8080 {
        header_down X-Real-IP {http.request.remote}
        header_down X-Forwarded-For {http.request.remote}
      }
    '';
    services.caddy.virtualHosts."photos.e.zaluru.com".extraConfig = ''
      reverse_proxy http://127.0.0.1:8080 {
        header_down X-Real-IP {http.request.remote}
        header_down X-Forwarded-For {http.request.remote}
      }
    '';
    services.caddy.virtualHosts."api.e.zaluru.com".extraConfig = ''
      reverse_proxy localhost:8080 {
        header_up Connection "Upgrade"
        header_up Upgrade "websocket"
      }
    '';

    sops.secrets =
      lib.genAttrs
        [
          "ente-encryption-key"
          "ente-hash-key"
          "ente-jwt-secret"
          "ente-s3-endpoint"
          "ente-s3-bucket"
          "ente-s3-secret"
          "ente-s3-key"
        ]
        (name: {
          owner = "ente";
        });
  };
}
