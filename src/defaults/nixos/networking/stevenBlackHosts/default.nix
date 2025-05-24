{ lib, config, ... }:
let
  inherit (lib) mkDefault mkIf hasAttrByPath;
  hasStevenBlackHosts = hasAttrByPath [
    "networking"
    "stevenBlackHosts"
  ] config.networking;
in
{
  config = mkIf hasStevenBlackHosts {
    networking.stevenBlackHosts.enable = mkDefault true;
    networking.stevenBlackHosts.blockFakenews = mkDefault true;
    networking.stevenBlackHosts.blockGambling = mkDefault true;
  };
}
