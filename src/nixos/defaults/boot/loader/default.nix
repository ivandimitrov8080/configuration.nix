{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  boot.loader.efi.canTouchEfiVariables = mkDefault true;
}
