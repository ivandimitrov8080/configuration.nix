{
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Ivan Kirilov Dimitrov";
    userEmail = "ivan@idimitrov.dev";
    signing = {
      signByDefault = true;
      key = "ivan@idimitrov.dev";
    };
    extraConfig = {
      color.ui = "auto";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    aliases = {
      a = "add .";
      c = "commit";
      d = "diff --cached";
      p = "push";
    };
  };
}
