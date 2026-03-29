{ lib }:
let
  inherit (lib) mkDefault mkOverride;
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
  find = e: root: with builtins; (filter (x: endsWith e x) (lib.filesystem.listFilesRecursive root));
  findDefaults = root: find "default.nix" root;
  findJars = root: find ".jar" root;
  specialOpts = [
    "package"
    "src"
    "theme"
    "dnscrypt-proxy"
    "kernelPackages"
    "defaultUserShell"
  ];
  excludeOpts = [
    "initExtra"
    "interactiveShellInit"
    "keybindings"
    "extraConfig"
  ];
  shittyDefaults = [
    "splashImage"
  ];
  mkDefaultAttrs =
    a:
    builtins.mapAttrs (
      n: v:
      if builtins.elem n excludeOpts then
        v
      else if builtins.elem n shittyDefaults then
        mkOverride 990 v
      else if builtins.isFunction v then
        v
      else if builtins.isList v then
        v
      else if builtins.isAttrs v then
        if builtins.elem n specialOpts then mkDefault v else mkDefaultAttrs v
      else
        mkDefault v
    ) a;
}
