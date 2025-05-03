{ lib, ... }:
rec {
  endsWith =
    e: x:
    with builtins;
    let
      se = toString e;
      sx = toString x;
    in
    (stringLength sx >= stringLength se)
    && (substring ((stringLength sx) - (stringLength se)) (stringLength sx) sx) == se;
  findDefaults =
    root:
    with builtins;
    (filter (x: endsWith "default.nix" x) (lib.filesystem.listFilesRecursive root));
}
