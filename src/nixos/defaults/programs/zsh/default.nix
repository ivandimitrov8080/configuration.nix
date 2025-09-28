_: {
  programs.zsh.enableBashCompletion = true;
  programs.zsh.vteIntegration = true;
  programs.zsh.setOptions = [
    "INC_APPEND_HISTORY"
    "SHARE_HISTORY"
  ];
}
