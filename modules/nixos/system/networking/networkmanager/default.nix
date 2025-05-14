{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkEnableOption mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.system.networking.networkmanager;

in
{
  options.mine.system.networking.networkmanager = {
    enable = mkEnableOption "Enable NetworkManager";
    hostname = mkOpt types.str "" "Hostname";
    applet = mkEnableOption "Enable desktop applet";
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = "${cfg.hostname}";
      networkmanager = {
        enable = true;
        #wifi.macAddress = "random"
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };
    };

    users.users.${user.name}.extraGroups = [ "networkmanager" ];
    # slows down boot time when enabled
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    programs.nm-applet.enable = mkIf cfg.applet true;
  };
}
