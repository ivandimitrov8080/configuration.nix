{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  boot.plymouth.theme = mkDefault "rings";
  boot.plymouth.themePackages = mkDefault [ pkgs.adi1090x-plymouth-themes ];
}
