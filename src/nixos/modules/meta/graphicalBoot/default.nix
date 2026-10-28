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
    mkOption
    optionalString
    types
    ;
  cfg = config.meta.graphicalBoot;
in
{
  options.meta.graphicalBoot = {
    enable = mkEnableOption "enable graphical boot config";
    plymouthTheme = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Optional Plymouth theme file passed to the greeter. Set this only on
        hosts whose theme package is actually installed.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session =
          let
            greeter = lib.getExe pkgs.ndlm;
            themeArg = optionalString (cfg.plymouthTheme != null) "--theme-file ${cfg.plymouthTheme}";
          in
          {
            command = lib.mkForce "${greeter} ${themeArg}";
            user = "greeter";
          };
      };
    };
    boot = {
      loader = {
        limine.enable = true;
        # Limine owns boot here; do not leave the shared GRUB defaults active.
        grub.enable = false;
      };
      plymouth.enable = true;
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
    users.users.greeter = {
      extraGroups = [
        "video"
        "input"
        "render"
      ];
    };
  };
}
