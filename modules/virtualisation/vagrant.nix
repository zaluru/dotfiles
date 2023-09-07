{ config
, pkgs
, ... }:

{
  environment.systemPackages = with pkgs; [
    vagrant
    nfs-utils
  ];
  # https://nixos.wiki/wiki/Vagrant#Using_NFS_mounts
  # Minimal configuration for NFS support with Vagrant.
  services.nfs.server.enable = true;

  # the above does not seem to be enought
  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  
  # TODO have to figure out what firewall rules are required for nfs and vagrant, for now have to turn off the firewall
  # Add firewall exception for VirtualBox provider 
  networking = {
    firewall = {
      extraCommands = ''
        ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
        
        # allow NFSv3, NFSv4, mountd, rpcbind for nfs mounting
        ip46tables -A INPUT -i vboxnet+ -p tcp -m multiport --sports 2049,111,2048 -j ACCEPT
        ip46tables -A INPUT -i vboxnet+ -p udp -m multiport --sports 2049,111,2048 -j ACCEPT
        ip46tables -A INPUT -i virbr+ -p tcp -m multiport --sports 2049,111,2048 -j ACCEPT
        ip46tables -A INPUT -i virbr+ -p udp -m multiport --sports 2049,111,2048 -j ACCEPT

        # allow NFSv3, NFSv4, mountd, rpcbind for nfs mounting
        ip46tables -A INPUT -i vboxnet+ -p tcp -m multiport --dports 2049,111,2048 -j ACCEPT
        ip46tables -A INPUT -i vboxnet+ -p udp -m multiport --dports 2049,111,2048 -j ACCEPT
        ip46tables -A INPUT -i virbr+ -p tcp -m multiport --dports 2049,111,2048 -j ACCEPT
        ip46tables -A INPUT -i virbr+ -p udp -m multiport --dports 2049,111,2048 -j ACCEPT

      '';

      # Add firewall exception for libvirt provider when using NFSv4 
      interfaces."virbr1" = {                                   
        allowedTCPPorts = [ 2049 ];                                               
        allowedUDPPorts = [ 2049 ];                                               
      };     
    };
  };
}
