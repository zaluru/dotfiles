{ lib, config, pkgs, ... }:
let

  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.nix.distributed-builds;

in
{
  options.mine.system.nix.distributed-builds = {
    enable = mkEnableOption "Enable distributed builds";
  };
	#TODO: not tested, WIP

  config = mkIf cfg.enable {
	nix.buildMachines = [ {
		hostName = "zaluru.com";
		system = "x86_64-linux";
		protocol = "ssh-ng";
		maxJobs = 2;
		speedFactor = 2;
		supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
		mandatoryFeatures = [ ];
	}] ;
	nix.distributedBuilds = true;
	# optional, useful when the builder has a faster internet connection than yours
	nix.extraOptions = ''
	  builders-use-substitutes = true
	'';
  };
}