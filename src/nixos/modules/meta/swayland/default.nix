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
    security.pam.services.swaylock = { };
    environment.sessionVariables.XDG_DATA_DIRS = [ "${pkgs.sway}/share" ];
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
      config.sway.default = "wlr";
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
