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
    programs.sway.enable = true;
    programs.sway.package = pkgs.swayfx;
    programs.sway.wrapperFeatures.gtk = true;
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
    environment.systemPackages = with pkgs; [
      audacity
      brightnessctl
      gimp
      grim
      libnotify
      libreoffice-qt
      mupdf
      pwvucontrol
      screenshot
      slurp
      wl-clipboard
      volume
    ];
    security = {
      sudo = {
        extraRules = [
          {
            groups = [ "wheel" ];
            commands = [
              {
                command = "${pkgs.brightnessctl}/bin/brightnessctl";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      };
      polkit.enable = true;
      rtkit.enable = true;
    };
  };
}
