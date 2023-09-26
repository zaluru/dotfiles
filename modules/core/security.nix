{ config
, pkgs
, lib
, inputs
, ... }:

{
  environment.systemPackages = with pkgs; [
    doas-sudo-shim
    inputs.agenix.packages."${system}".default
  ];

  security = {
    pam = {
      services = {
        #gdm.enableGnomeKeyring = true;
        #swaylock = {
        #  text = ''
        #    auth include login
        #  '';
        #};
      };
    };

    doas = {
      enable = true;
      extraRules = [
        {
          groups = ["wheel"];
          persist = true;
          keepEnv = false;
        }
        {
          groups = ["power"];
          noPass = true;
          cmd = "${pkgs.systemd}/bin/poweroff";
        }
        {
          groups = ["power"];
          noPass = true;
          cmd = "${pkgs.systemd}/bin/reboot";
        }
        {
          groups = ["nix"];
          cmd = "nix-collect-garbage";
          noPass = true;
        }
        {
          groups = ["nix"];
          cmd = "nixos-rebuild";
          keepEnv = true;
        }
      ];
    };
    sudo.enable = false;
  };
}
