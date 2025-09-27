{ pkgs, ... }:
let
  shells = with pkgs; [
    bash
    zsh
    nushell
  ];
in
{
  environment.shells = shells;
}
