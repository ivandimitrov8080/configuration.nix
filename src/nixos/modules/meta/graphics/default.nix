{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.meta.graphics;
in
{
  options.meta.graphics = {
    enable = mkEnableOption "graphics drivers and the base xdg portal";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable = true;
    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
