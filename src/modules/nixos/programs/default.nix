_: {
  programs = {
    git = {
      enable = true;
      config = {
        safe.directory = "*";
      };
    };
    zsh.enable = true;
    nix-ld.enable = true;
  };
}
