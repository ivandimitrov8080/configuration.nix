{ config, lib, ... }:
with lib;
let
  cfg = config.flatpak;
in
{
  config = mkIf cfg.flatpak.enable {
    xdg = {
      portal = {
        enable = mkDefault true;
        wlr.enable = mkDefault true;
        config.common.default = mkDefault "*";
      };
    };
  };
}
