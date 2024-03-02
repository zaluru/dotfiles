{ ... }:

{
  virtualisation.oci-containers.containers."obs-web" = {
	autoStart = true;
	ports = [ "5000:5000" ]; 
	image = "ghcr.io/niek/obs-web:latest";
	volumes = [
	];
	extraOptions = [
	];
  };	
}
