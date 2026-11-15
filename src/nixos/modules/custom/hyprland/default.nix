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
    meta.graphics.enable = true;
    programs.hyprlock.enable = true;
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;
    programs.hyprland.systemd.setPath.enable = true;
    services.seatd.enable = true;
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
}
