{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [ "--enable-features=VaapiVideoDecodeLinuxGL" ];
  };
}
