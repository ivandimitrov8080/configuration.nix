{ lib, ... }:
let
  inherit (import ../../lib { inherit lib; }) endsWith findDefaults;
in
{
  imports = with builtins; filter (x: !(endsWith "defaults/nixos/default.nix" x)) (findDefaults ./.);
}
