{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.git.config.saveDirectory = mkDefault "*";
}
