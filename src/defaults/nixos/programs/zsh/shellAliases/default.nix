{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.zsh.shellAliases = mkDefault {
    cal = "cal $(date +%Y)";
    gad = "git add . && git diff --cached";
    gac = "ga && gc";
    gco = "git checkout";
    ga = "git add .";
    gc = "git commit";
    dev = "nix develop";
    eza = "eza '--long' '--header' '--icons' '--smart-group' '--mounts' '--group-directories-first' '--octal-permissions' '--git'";
    ls = "eza";
    la = "eza --all -a";
    lt = "eza --git-ignore --all --tree --level=10";
    sc = "systemctl";
    neofetch = "fastfetch -c all.jsonc";
    flip = "shuf -r -n 1 -e Heads Tails";
  };
}
