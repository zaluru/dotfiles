{ config, lib, pkgs, inputs, ... }:

let
  username = "nix-on-droid";
in
{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    neovim # or some other editor, e.g. nano or neovim

    # Some common stuff that people expect to have
    diffutils
    findutils
    utillinux
    tzdata
    hostname
    man
    gnugrep
    gnupg
    gnused
    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    git
    curl
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  environment.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish"; #TODO for some reason nix-on-droid does not set the default $SHELL and zellij starts /bin/sh
  };

  # Read the changelog before changing this value
  system.stateVersion = "23.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  user.shell = "${pkgs.fish}/bin/fish";

  terminal.font = "${pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFont-Medium.ttf";

  # Set your time zone
  time.timeZone = "Europe/Warsaw";

  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username; };
    
    config = {
      imports =
        [ (import ../home-zaluru.nix)];
    };
  };
}
