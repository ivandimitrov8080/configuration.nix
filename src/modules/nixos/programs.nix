{ lib, ... }:
{
  programs = with lib; {
    git = {
      config = {
        safe.directory = mkDefault "*";
      };
    };
    nix-ld.enable = mkDefault true;
    starship.enable = mkDefault true;
    zsh = {
      enableBashCompletion = mkDefault true;
      syntaxHighlighting.enable = mkDefault true;
      autosuggestions = {
        enable = mkDefault true;
        strategy = mkDefault [
          "history"
          "completion"
          "match_prev_cmd"
        ];
        highlightStyle = mkDefault "fg=#FFF689";
      };
      shellAliases = {
        cal = mkDefault "cal $(date +%Y)";
        GG = mkDefault "git add . && git commit -m 'GG' && git push --set-upstream origin HEAD";
        gad = mkDefault "git add . && git diff --cached";
        gac = mkDefault "ga && gc";
        ga = mkDefault "git add .";
        gc = mkDefault "git commit";
        dev = mkDefault "nix develop --command $SHELL";
        eza = mkDefault "${pkgs.eza}/bin/eza '--long' '--header' '--icons' '--smart-group' '--mounts' '--group-directories-first' '--octal-permissions' '--git'";
        ls = mkDefault "eza";
        la = mkDefault "eza --all -a";
        lt = mkDefault "eza --git-ignore --all --tree --level=10";
        sc = mkDefault "systemctl";
        neofetch = mkDefault "${pkgs.fastfetch}/bin/fastfetch -c all.jsonc";
        flip = mkDefault "shuf -r -n 1 -e Heads Tails";
      };
    };
  };
}
