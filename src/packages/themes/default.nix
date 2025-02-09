{ pkgs, lib, ... }:
let
  inherit (pkgs) callPackage;
  inherit (lib) makeExtensible extends;
  initial = self: { };
in
makeExtensible (
  extends (final: prev: {
    rofi = callPackage ./rofi.nix { };
    mutt = callPackage ./mutt.nix { };
    gtk = callPackage ./gtk-theme-catppuccin.nix { };
    plymouth = callPackage ./plymouth.nix { };
  }) initial
)
