{
  programs.git = {
    enable = true;
    userName = "Ivan Dimitrov";
    userEmail = "ivan@idimitrov.dev";
    extraConfig = {
      color.ui = "auto";
      pull.rebase = true;
    };
    aliases = {
      a = "add .";
      c = "commit";
      d = "diff --cached";
      p = "push";
    };
  };
}
