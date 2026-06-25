{
  lib,
  config,
  pkgs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.mine.apps.steam;

in
{
  options.mine.apps.steam = {
    enable = mkEnableOption "steam";
    hide-games-desktop-entry = mkOption {
      type = types.bool;
      default = false;
      description = "Hide Steam game icons from the application launcher.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      # TODO: when gamescope and bubblewrap get fixed
      #extraPackages = with pkgs; [ config.programs.gamescope.package ];
    };
    home-manager.users.${user.name} = { lib, ... }: {
      home.activation.hide-steam-games-desktop-entry = lib.mkIf cfg.hide-games-desktop-entry (
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          for f in ~/.local/share/applications/*.desktop; do
            grep -q 'steam://rungameid/' "$f" || continue
            grep -q '^NoDisplay=true' "$f" || echo 'NoDisplay=true' >> "$f"
          done
        ''
      );
    };
  };
}
