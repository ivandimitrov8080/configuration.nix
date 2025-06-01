{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.git.config.safe.directory = mkDefault "*";
}
