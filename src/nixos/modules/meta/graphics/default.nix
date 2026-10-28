# The graphics stack shared by every graphical environment. meta.swayland and
# meta.hyprland used to duplicate hardware.graphics.enable and the base
# xdg.portal block; they now only add their own portal.
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
