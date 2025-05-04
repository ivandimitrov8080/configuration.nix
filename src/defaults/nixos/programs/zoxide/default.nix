{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.zoxide.enableBashIntegration = mkDefault true;
  programs.zoxide.enableZshIntegration = mkDefault true;
}
