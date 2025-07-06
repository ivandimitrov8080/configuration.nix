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
  cfg = config.meta.hyprland;
in
{
  options.meta.hyprland = {
    enable = mkEnableOption "enable hyprland config";
  };
  config = mkIf cfg.enable {
    # hardware.graphics.enable = true;
    # hardware.graphics.extraPackages = with pkgs; [
    #   intel-media-driver
    #   intel-vaapi-driver
    # ];
    # programs.hyprlock.enable = true;
    programs.hyprland.enable = true;
    services.seatd.enable = true;
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-hyprland
    #     xdg-desktop-portal-gtk
    #   ];
    #   hyprland = {
    #     enable = true;
    #     settings = {
    #       screencast = {
    #         output_name = "HDMI-A-1";
    #         max_fps = 60;
    #       };
    #     };
    #   };
    # };
  };
}
