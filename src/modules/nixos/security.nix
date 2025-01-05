{ lib, pkgs, ... }:
with lib;
{
  security = {
    sudo = {
      execWheelOnly = mkDefault true;
      extraRules = mkDefault [
        { groups = [ "wheel" ]; }
      ];
    };
    polkit.enable = mkDefault true;
    rtkit.enable = mkDefault true;
  };
}
