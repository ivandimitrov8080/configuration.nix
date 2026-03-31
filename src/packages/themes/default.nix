{
  callPackage,
  lib,
  ...
}:
let
  inherit (lib) recurseIntoAttrs;
in
recurseIntoAttrs {
  rofi = callPackage ./rofi.nix { };
  mutt = callPackage ./mutt.nix { };
  gtk = callPackage ./gtk-theme-catppuccin.nix { };
}
