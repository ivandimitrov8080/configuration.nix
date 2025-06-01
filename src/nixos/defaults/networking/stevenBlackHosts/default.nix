{ lib, options, ... }:
let
  inherit (lib) mkDefault optionalAttrs;
  hasStevenBlackHosts = options.networking ? stevenBlackHosts;
in
{
  config = optionalAttrs hasStevenBlackHosts {
    networking.stevenBlackHosts.enable = mkDefault true;
    networking.stevenBlackHosts.blockFakenews = mkDefault true;
    networking.stevenBlackHosts.blockGambling = mkDefault true;
  };
}
