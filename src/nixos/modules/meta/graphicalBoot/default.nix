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
  cfg = config.meta.graphicalBoot;
in
{
  options.meta.graphicalBoot = {
    enable = mkEnableOption "enable graphical boot config";
  };

  config = mkIf cfg.enable {
    services.greetd.enable = true;
    programs.regreet.enable = true;
    boot = {
      plymouth.enable = true;
      initrd.systemd.enable = true;
      initrd.verbose = false;
      consoleLogLevel = 0;
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
