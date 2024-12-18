{ ... }:

{
  imports = [
    ./vaultwarden.nix
    ./obs-web.nix
    ./shiori.nix
  ];
  services.languagetool = {
    enable = true;
  };
}
