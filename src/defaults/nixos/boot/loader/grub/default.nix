{ lib, pkgs, ... }:
let
  inherit (lib) mkOverride mkDefault;
  theme = pkgs.sleek-grub-theme.override {
    withBanner = "Hello";
    withStyle = "bigSur";
  };
in
{
  boot.loader.grub.useOSProber = mkDefault true;
  boot.loader.grub.efiSupport = mkDefault true;
  boot.loader.grub.device = mkDefault "nodev";
  boot.loader.grub.theme = mkDefault theme;
  boot.loader.grub.splashImage = (mkOverride 999) "${theme}/background.png";
}
