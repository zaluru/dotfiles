{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.apps.blender;

in
{
  options.mine.apps.blender = {
    enable = mkOpt types.bool false "Enable Audacious";
  };

  config = mkIf cfg.enable {
    # TODO: WIP
    #home-manager.users.${user.name} = {
    #home.packages = with pkgs; [ blender-hip ];
    #error: blender-hip has been removed in favor of setting `config.rocmSupport = true`
    #};
  };
}
