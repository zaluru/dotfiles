{ ... }:

{
  networking = {
    # dns
    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "podman0" "rndis0"];
      wifi.macAddress = "random";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [443 80 22 7000 8080 5432];
      allowedUDPPorts = [443 80 44857 8080];
      allowPing = false;
      # if packets are still dropped, they will show up in dmesg
      logReversePathDrops = true;
      # wireguard trips rpfilter up
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };
  };
  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;
}

