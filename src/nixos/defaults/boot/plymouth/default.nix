{ pkgs, ... }:
{
  boot.plymouth.theme = "catppuccin-mocha";
  boot.plymouth.themePackages = [
    (pkgs.catppuccin-plymouth.override { variant = "mocha"; })
  ];
}
