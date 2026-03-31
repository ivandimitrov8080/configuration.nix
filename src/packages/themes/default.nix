{
  callPackage,
  lib,
  ...
}:
let
  inherit (lib) recurseIntoAttrs;
in
recurseIntoAttrs {
  aerc = callPackage ./aerc.nix { };
  gtk = callPackage ./gtk-theme-catppuccin.nix { };
  mutt = callPackage ./mutt.nix { };
  rofi = callPackage ./rofi.nix { };
}
