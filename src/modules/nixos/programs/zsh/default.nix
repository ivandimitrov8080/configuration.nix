{ pkgs, ... }:
{
  programs = {
    starship.enable = true;
    zsh = {
      enableBashCompletion = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "cursor"
          "root"
          "line"
        ];
      };
      vteIntegration = true;
      autosuggestions = {
        enable = true;
        strategy = [
          "history"
          "completion"
          "match_prev_cmd"
        ];
        highlightStyle = "fg=cyan";
      };
      shellAliases = {
        cal = "cal $(date +%Y)";
        GG = "git add . && git commit -m 'GG' && git push --set-upstream origin HEAD";
        gad = "git add . && git diff --cached";
        gac = "ga && gc";
        ga = "git add .";
        gc = "git commit";
        dev = "nix develop --command $SHELL";
        eza = "${pkgs.eza}/bin/eza '--long' '--header' '--icons' '--smart-group' '--mounts' '--group-directories-first' '--octal-permissions' '--git'";
        ls = "eza";
        la = "eza --all -a";
        lt = "eza --git-ignore --all --tree --level=10";
        sc = "systemctl";
        neofetch = "${pkgs.fastfetch}/bin/fastfetch -c all.jsonc";
        flip = "shuf -r -n 1 -e Heads Tails";
      };
    };
  };
}
