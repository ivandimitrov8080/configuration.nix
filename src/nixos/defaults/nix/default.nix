{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  nix.extraOptions = mkDefault "experimental-features = nix-command flakes";
}
