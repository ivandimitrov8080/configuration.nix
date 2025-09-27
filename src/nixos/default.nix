{
  pkgs,
  lib,
  options,
  config,
  ...
}:
let
  inherit (import ../lib { inherit lib; }) findDefaults mkDefaultAttrs;
  mods = findDefaults ./modules;
  defs = builtins.map (
    f: mkDefaultAttrs (import f { inherit pkgs lib options config; })
  ) (findDefaults ./defaults);
in
{
  imports = mods ++ defs;
}
