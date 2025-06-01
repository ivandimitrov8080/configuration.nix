{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.zsh.enableBashCompletion = mkDefault true;
  programs.zsh.vteIntegration = mkDefault true;
}
