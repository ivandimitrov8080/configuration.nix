{
  programs.lf = {
    enable = true;
    extraConfig = builtins.readFile ./lfrc;
    keybindings = {
      D = "trash";
      T = "touch";
      M = "mkdir";
      R = "mv";
    };
  };
}
