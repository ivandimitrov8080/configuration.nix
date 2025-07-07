{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  nix.settings.trusted-users = mkDefault [ "@wheel" ];
  nix.settings.auto-optimise-store = mkDefault true;
  nix.settings.max-jobs = mkDefault "auto";
}
