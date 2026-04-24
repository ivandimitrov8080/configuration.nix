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
  cfg = config.meta.graphicalBoot;
in
{
  options.meta.graphicalBoot = {
    enable = mkEnableOption "enable graphical boot config";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session =
          let
            greeter = lib.getExe pkgs.ndlm;
            session = "--session ${pkgs.swayfx}/bin/sway";
            themeFile = "--theme-file /etc/plymouth/themes/catppuccin-mocha/catppuccin-mocha.plymouth";
          in
          {
            command = lib.mkForce "${greeter} ${session} ${themeFile}";
            user = "greeter";
          };
      };
    };
    boot = {
      loader.grub.enable = true;
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
    users.users.greeter = {
      extraGroups = [
        "video"
        "input"
        "render"
      ];
    };
  };
}
