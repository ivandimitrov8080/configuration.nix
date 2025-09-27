_: {
  nix.settings.trusted-users = [ "@wheel" ];
  nix.settings.auto-optimise-store = true;
  nix.settings.max-jobs = "auto";
}
