{ ... }:

{
  # If no changes happen check flatpak-managed-install.service

  home.file.".var/app/com.brave.Browser/config/source-brave-flags.conf" = {
    text = ''
      --ozone-platform=wayland
      --enable-features=VaapiVideoDecodeLinuxGL,WebRTCPipeWireCapturer
    '';
    # have to copy it from the symlink becouse the flatpak has no permission to read the nix store
    onChange = ''
      rm -f ~/.var/app/com.brave.Browser/config/brave-flags.conf
      cp -L ~/.var/app/com.brave.Browser/config/source-brave-flags.conf ~/.var/app/com.brave.Browser/config/brave-flags.conf
      chmod 0444 ~/.var/app/com.brave.Browser/config/brave-flags.conf
    '';
  };
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    uninstallUnmanaged = true;
    packages = [
      "com.github.tchx84.Flatseal"
      "com.brave.Browser"
      "org.signal.Signal"
      "com.bitwarden.desktop"
      "re.sonny.Workbench"
      "so.libdb.dissent"
      "md.obsidian.Obsidian"
      "im.nheko.Nheko"
      "org.kde.krita"

      #"com.obsproject.Studio"
      # Capture vulkan and opengl games bypassing the compositor - https://github.com/nowrep/obs-vkcapture
      #"com.obsproject.Studio.Plugin.OBSVkCapture"
      "org.freedesktop.Platform.VulkanLayer.OBSVkCapture//23.08"
      "org.freedesktop.Platform.VulkanLayer.OBSVkCapture//24.08"

      "org.gtk.Gtk3theme.adw-gtk3"
      "org.gtk.Gtk3theme.adw-gtk3-dark"

      # Game console emulators
      "org.duckstation.DuckStation"
      "net.pcsx2.PCSX2"
      "net.rpcs3.RPCS3"
    ];
    overrides = {
      "com.brave.Browser" = {
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
      };
      "org.signal.Signal" = {
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
      };
    };
  };
}
