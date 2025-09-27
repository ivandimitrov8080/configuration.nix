{ lib, options, ... }:
let
  inherit (lib) optionalAttrs;
  hasStevenBlackHosts = options.networking ? stevenBlackHosts;
in
{
  config = optionalAttrs hasStevenBlackHosts {
    networking.stevenBlackHosts.enable = true;
    networking.stevenBlackHosts.blockFakenews = true;
    networking.stevenBlackHosts.blockGambling = true;
  };
}
