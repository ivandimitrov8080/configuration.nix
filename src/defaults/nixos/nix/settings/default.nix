{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  nix.settings.trustedUsers = mkDefault [ "@wheel" ];
  nix.settings.auto-optimise-store = mkDefault true;
}
