{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.audio.qpwgraph;

in
{
  options.mine.system.audio.qpwgraph = {
    enable = mkEnableOption "Element qpwgraph - pipewire patchbay and graph manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qpwgraph
    ];
    home-manager.users.${user.name} = {
      xdg.configFile."autostart/org.rncbc.qpwgraph.desktop".text = builtins.readFile "${pkgs.qpwgraph}/share/applications/org.rncbc.qpwgraph.desktop";
    };
  };
}