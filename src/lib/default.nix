{ lib }:
let
  inherit (lib) mkDefault mkOverride;
in
rec {
  # Plain shared values (aliases, flags, ...) used by both module trees.
  values = import ./data.nix;

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
