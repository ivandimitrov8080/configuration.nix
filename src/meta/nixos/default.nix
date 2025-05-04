{ lib, ... }:
let
  inherit (import ../../lib { inherit lib; }) endsWith findDefaults;
in
{
  imports = (with builtins; filter (x: !((endsWith "meta/nixos/default.nix" x))) (findDefaults ./.));
}
