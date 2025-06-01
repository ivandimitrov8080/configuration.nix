{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  environment.enableAllTerminfo = mkDefault true;
}
