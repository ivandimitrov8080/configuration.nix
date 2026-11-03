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
        timeout = 1;
        limine = {
          enable = true;
          extraConfig = ''
            quiet: yes
          '';
        };
      };
      plymouth.enable = true;
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
