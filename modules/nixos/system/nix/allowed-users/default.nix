_: {
  nix.settings = {
    # allow sudo users to mark the following values as trusted
    allowed-users = [ "@wheel" ];
    # only allow sudo users to manage the nix store
    trusted-users = [ "@wheel" ];
  };
}