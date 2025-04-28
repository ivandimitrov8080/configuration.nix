{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.graphicalBoot;
in
{
  options.graphicalBoot = {
    enable = mkEnableOption "enable graphical boot config";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
    };
    programs.regreet = {
      enable = true;
    };
    environment.etc."xdg/wayland-sessions/sway.desktop".source =
      "${pkgs.sway}/share/wayland-sessions/sway.desktop";
    boot = {
      initrd.systemd.enable = true;
      plymouth = {
        enable = true;
        theme = "rings";
        themePackages = with pkgs; [
          adi1090x-plymouth-themes
        ];
      };
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };
  };
}
