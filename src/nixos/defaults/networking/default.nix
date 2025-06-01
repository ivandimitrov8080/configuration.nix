{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  networking.useNetworkd = mkDefault true;
}
