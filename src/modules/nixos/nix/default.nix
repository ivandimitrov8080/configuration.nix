_: {
  nix = {
    extraOptions = ''experimental-features = nix-command flakes'';
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
    };
  };
}
