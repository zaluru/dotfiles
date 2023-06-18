{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nix = {
    gc = {
      automatic= true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      # allow sudo users to mark the following values as trusted
      allowed-users = ["@wheel"];
      # only allow sudo users to manage the nix store
      trusted-users = ["@wheel"];
      
      experimental-features = ["nix-command" "flakes"];
    };
  };
}
