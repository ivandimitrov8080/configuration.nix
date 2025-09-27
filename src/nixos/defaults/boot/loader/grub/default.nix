{ pkgs, ... }:
let
  theme = pkgs.catppuccin-grub.override {
    flavor = "mocha";
  };
in
{
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.theme = theme;
  boot.loader.grub.splashImage = "${theme}/background.png";
}
