{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.bash.blesh.enable = mkDefault true;
}
