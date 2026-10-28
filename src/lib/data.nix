# Plain values shared by the NixOS tree and the Home Manager tree. The two
# option trees cannot be shared (their option names differ), but the values
# they carry can, so every duplicated setting lives here exactly once.
let
  ezaFlags = [
    "--long"
    "--header"
    "--icons"
    "--smart-group"
    "--mounts"
    "--group-directories-first"
    "--octal-permissions"
    "--git"
  ];
in
rec {
  inherit ezaFlags;

  # Aliases valid in bash/zsh/nushell alike.
  shellAliases = {
    sc = "systemctl";
    flip = "shuf -r -n 1 -e Heads Tails";
  };

  # Only added when zoxide is enabled; `z` rejects its own name.
  zoxideAliases = {
    cd = "z";
    cdi = "zi";
  };

  ezaAliases = {
    eza = "eza ${builtins.concatStringsSep " " ezaFlags}";
    le = "eza";
    la = "eza --all -a";
    lt = "eza --git-ignore --all --tree --level=10";
  };

  # Values only: the NixOS options are `autosuggestions.highlightStyle` and
  # `syntaxHighlighting.highlighters`, Home Manager spells them
  # `autosuggestion.highlight` and `syntaxHighlighting.highlighters`.
  zsh = {
    setOptions = [
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
      "VI"
    ];
    highlighters = [
      "main"
      "brackets"
      "cursor"
      "line"
    ];
    highlightStyle = "fg=cyan";
    autosuggestionStrategy = [
      "history"
      "completion"
      "match_prev_cmd"
    ];
  };
}
