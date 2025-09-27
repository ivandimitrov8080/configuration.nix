{ pkgs, ... }:
let
  theme = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    size = "compact";
    accents = [
      "maroon"
    ];
  };
in
{
  programs.regreet.theme.package = theme;
  programs.regreet.theme.name = "catppuccin-mocha-maroon-compact";
}
