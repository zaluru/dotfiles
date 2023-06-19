{
  config,
  pkgs,
  lib,
  ...
}: {

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };
}
