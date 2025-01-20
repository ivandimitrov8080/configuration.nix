{ pkgs, ... }:
{
  hardware.graphics.enable = true;
  security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config.sway.default = "wlr";
    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "HDMI-A-1";
          max_fps = 60;
        };
      };
    };
    config.common.default = "*";
  };
}
