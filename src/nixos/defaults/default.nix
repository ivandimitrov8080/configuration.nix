{ lib, ... }:
let
  inherit (import ../../lib { inherit lib; }) endsWith findDefaults mkDefaultAttrs;
in
mkDefaultAttrs {
  imports = with builtins; filter (x: !(endsWith "defaults/default.nix" x)) (findDefaults ./.);
}
