{ pkgs
, ...}:

{
  systemd.services = {
    seatd = {
      enable = true;
      description = "Seat management daemon";
      script = "${pkgs.seatd}/bin/seatd -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
      };
      wantedBy = ["multi-user.target"];
    };
  };

  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];
  
  # Required for tuigreet remembering last users and sessions
  # TODO figure out how to add that to the tuigreet package
  #systemd.tmpfiles.rules = [
  #  "d /var/cache/tuigreet 0700 greeter greeter "
  #];
  security.polkit.enable = true;
  services = {
    mullvad-vpn.enable = false; # too broke rn :(
    greetd = {
      enable = false;
      #settings = rec {
        #initial_session = {
          # TODO Change default X_SESSIONS and WAYLAND_SESSIONS in https://github.com/apognu/tuigreet/blob/599d8d5d3657e6c25b3877f84a09979a79256600/src/info.rs#L15-L16
          #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-user-session --sessions /run/current-system/sw/share/xsessions:/run/current-system/sw/share/wayland-sessions:/run/booted-system/etc/profiles/per-user/zaluru/share/wayland-sessions:/run/booted-system/etc/profiles/per-user/zaluru/share/xsessions";
          #user = "greeter";
        #};
        #default_session = initial_session;
      #};
    };

    xserver.displayManager.gdm = {
      enable = true;
      wayland = true; 
    };

    tailscale.enable = true;

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
#    logind = {
#      lidSwitch = "suspend-then-hibernate";
#      lidSwitchExternalPower = "lock";
#      extraConfig = ''
#        HandlePowerKey=suspend-then-hibernate
#        HibernateDelaySec=3600
#      '';
#    };

#    lorri.enable = true;
    udisks2.enable = true;
    printing.enable = true;
    fstrim.enable = true;
  };
}
