{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
  theme = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    size = "compact";
    accents = [
      "maroon"
    ];
  };
in
{
  programs.regreet.theme.package = mkDefault theme;
  programs.regreet.theme.name = mkDefault "catppuccin-mocha-maroon-compact";
}
