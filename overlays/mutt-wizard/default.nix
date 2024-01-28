(final: prev: {
  mutt-wizard = prev.mutt-wizard.override {
    src = final.fetchFromGitHub {
      owner = "LukeSmithxyz";
      repo = "mutt-wizard";
      rev = "main"; # Use the latest commit from the main branch
      sha256 = ""; # You can remove the sha256 if you want Nix to calculate it
    };
  };
})
