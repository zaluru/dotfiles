{ pkgs 
, ... }:

{
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    includes = [ "personal/config" ];
  };
  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
}
