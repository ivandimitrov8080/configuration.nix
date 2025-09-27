_: {
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.autosuggestions.highlightStyle = "fg=cyan";
  programs.zsh.autosuggestions.strategy = [
    "history"
    "completion"
    "match_prev_cmd"
  ];
}
