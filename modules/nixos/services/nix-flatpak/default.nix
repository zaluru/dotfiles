{
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (config.mine) user;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.services.nix-flatpak;

in
{
  options.mine.services.nix-flatpak = {
    enable = mkEnableOption "Enable nix-flatpak - declarative flatpak management.";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    home-manager.users.${user.name} = {
      imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
      #home.file.".var/app/com.brave.Browser/config/source-brave-flags.conf" = {
      #  text = ''
      #    --ozone-platform=wayland
      #    --enable-features=VaapiVideoDecodeLinuxGL,WebRTCPipeWireCapturer
      #  '';
      #  # have to copy it from the symlink becouse the flatpak has no permission to read the nix store
      #  onChange = ''
      #    rm -f ~/.var/app/com.brave.Browser/config/brave-flags.conf
      #    cp -L ~/.var/app/com.brave.Browser/config/source-brave-flags.conf ~/.var/app/com.brave.Browser/config/brave-flags.conf
      #    chmod 0444 ~/.var/app/com.brave.Browser/config/brave-flags.conf
      #  '';
      #};
      services.flatpak = {
        enable = true;
        update.auto.enable = true;
        uninstallUnmanaged = true;
        packages = [
          "com.github.tchx84.Flatseal"
          "org.kde.krita"
          "info.beyondallreason.bar"

          #"com.obsproject.Studio"
          # Capture vulkan and opengl games bypassing the compositor - https://github.com/nowrep/obs-vkcapture
          #"com.obsproject.Studio.Plugin.OBSVkCapture"
          #"org.freedesktop.Platform.VulkanLayer.OBSVkCapture//23.08"
          #"org.freedesktop.Platform.VulkanLayer.OBSVkCapture//24.08"

          "org.gtk.Gtk3theme.adw-gtk3"
          "org.gtk.Gtk3theme.adw-gtk3-dark"

          # Game console emulators
          "org.duckstation.DuckStation"
          "net.pcsx2.PCSX2"
          "net.rpcs3.RPCS3"
        ];
        overrides = {
          #"com.brave.Browser" = {
          #  Context.sockets = [
          #    "wayland"
          #    "!x11"
          #    "!fallback-x11"
          #  ];
          #};
        };
      };
    };
  };
}