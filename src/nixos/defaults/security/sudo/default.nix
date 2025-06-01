{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  security.sudo.execWheelOnly = mkDefault true;
}
