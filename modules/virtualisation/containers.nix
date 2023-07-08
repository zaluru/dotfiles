{ config
, pkgs
, lib
, ... }:

{
  virtualisation.oci-containers.containers = {
    "gluetun" = {
      image = "ghcr.io/qdm12/gluetun";
      extraOptions = ["-it" "--rm" "--cap-add=NET_ADMIN"];
      environment = {
        VPN_SERVICE_PROVIDER = "mullvad";
        VPN_TYPE = "wireguard";
        #WIREGUARD_PRIVATE_KEY = "";
        #WIREGUARD_ADRESSES= "";
        #SERVER_CITIES = "";
        SERVER_COUNTRIES = "Sweden,Norway,Finland";
        OWNED_ONLY = "yes";
      };
      autoStart = false;
    };
    "qbittorrent" = {
      image = "linuxserver/qbittorrent:4.5.2";
      autoStart = false;
    };
  };
}
