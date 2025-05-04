{ pkgs, lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.zsh.autosuggestions.enable = mkDefault true;
  programs.zsh.autosuggestions.highlightStyle = mkDefault "fg=cyan";
  programs.zsh.autosuggestions.strategy = mkDefault [
    "history"
    "completion"
    "match_prev_cmd"
  ];
}
