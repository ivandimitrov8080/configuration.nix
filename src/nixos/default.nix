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
  defs = mkDefaultAttrs (
    import ./defaults {
      inherit
        pkgs
        config
        lib
        options
        ;
    }
  );
in
{
  imports = mods ++ [ defs ];
}
