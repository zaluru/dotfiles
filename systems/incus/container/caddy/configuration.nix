{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  inherit (lib.zaluru) enabled;
  inherit (config.mine) user;

in
{
  imports = [
    ../../../../overlays/inputs
    (inputs.import-tree ../../../../modules)
    inputs.nix-private-config.nixosModules.configs
  ];

  config = {
    services.caddy = {
      enable = true;
      globalConfig = ''    
        acme_dns bunny {
          access_key {$BUNNY_API_KEY}
        }
      '';
      package = pkgs.caddy.withPlugins {
        plugins = [ 
          "github.com/caddy-dns/bunny@v1.2.0"
          #"github.com/lixmal/caddy-netbird@v0.2.28" # Wait for the new version where --replace is not needed
        ];
        hash = "sha256-92prKdGudX4MAEfUjyCrtpWoy6p5rwYxEEDnzLg2fmI=";
      };
    };
  
    sops.secrets."bunny-net-api-key" = {};
    sops.templates."caddy_dns_bunny.env" = {
      content = ''
        BUNNY_API_KEY=${config.sops.placeholder."bunny-net-api-key"}
      '';
      owner = config.systemd.services.caddy.serviceConfig.User;
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = ["${config.sops.templates."caddy_dns_bunny.env".path}" ];

    mine = {
      trait = {
        secrets.sops = enabled;
      };
      system.networking.hostName = "incus-caddy";
    };

    system.stateVersion = "26.05";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}