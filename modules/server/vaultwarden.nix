{ ... }:

{
  services.vaultwarden.enable = true;
  programs.goldwarden.enable = true;
  programs.goldwarden.useSshAgent = false;
}
