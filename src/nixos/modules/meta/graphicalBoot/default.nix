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
    services.greetd.settings.default_session.command =
      lib.mkDefault "${lib.getExe pkgs.greetd.tuigreet} --time --remember --theme 'text=#cdd6f4;time=#f9e2af;container=#1e1e2e;border=#45475a;title=#f5c2e7;greet=#f38ba8;prompt=#a6e3a1'";
    services.kmscon.enable = true;
    services.kmscon.hwRender = true;
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
