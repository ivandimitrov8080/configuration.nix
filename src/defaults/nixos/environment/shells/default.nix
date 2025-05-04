{ pkgs, lib, ... }:
let
  inherit (lib) mkDefault;
  shells = with pkgs; [
    bash
    zsh
    nushell
  ];
in
{
  environment.shells = mkDefault shells;
}
