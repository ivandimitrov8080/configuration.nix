{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  boot.plymouth.theme = mkDefault "catppuccin-mocha";
  boot.plymouth.themePackages = mkDefault [
    (pkgs.catppuccin-plymouth.override { variant = "mocha"; })
  ];
}
