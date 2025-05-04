{ pkgs, lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.zsh.syntaxHighlighting.enable = mkDefault true;
  programs.zsh.syntaxHighlighting.highlighters = mkDefault [
    "main"
    "brackets"
    "cursor"
    "line"
  ];
}
