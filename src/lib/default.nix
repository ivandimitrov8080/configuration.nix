{ lib }:
let
  inherit (lib) mkOverride;
in
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
  specialOpts = [
    "package"
    "src"
    "theme"
    "settings"
  ];
  mkDefaultAttrs =
    a:
    builtins.mapAttrs (
      n: v:
      if builtins.isAttrs v then
        if builtins.elem n specialOpts then mkOverride 900 v else mkDefaultAttrs v
      else if builtins.isFunction v then
        v
      else if builtins.isList v then
        v
      else
        mkOverride 900 v
    ) a;
}
