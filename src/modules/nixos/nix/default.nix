_: {
  nix = {
    extraOptions = ''experimental-features = nix-command flakes'';
    settings.trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
