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

  shellAliases = {
    sc = "systemctl";
    flip = "shuf -r -n 1 -e Heads Tails";
  };

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

  zsh = {
    setOptions = [
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
    ];
    highlighters = [
      "main"
      "brackets"
      "cursor"
      "line"
    ];
    autosuggestionStrategy = [
      "history"
      "completion"
      "match_prev_cmd"
    ];
  };
}
