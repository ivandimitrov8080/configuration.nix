{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.meta.swayland;
in
{
  options.meta.swayland = {
    enable = mkEnableOption "enable swayland config";
  };
  config = mkIf cfg.enable {
    hardware.graphics.enable = true;
    programs.hyprlock.enable = true;
    programs.sway.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
      wlr = {
        enable = true;
        settings = {
          screencast = {
            output_name = "HDMI-A-1";
            max_fps = 60;
          };
        };
      };
    };
  };
}
