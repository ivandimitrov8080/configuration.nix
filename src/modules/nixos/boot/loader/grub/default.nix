{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    ;
  inherit (lib.types)
    bool
    ;
  cfg = config.grubBoot;
in
{
  options.grubBoot = {
    enable = mkEnableOption "enable grub config";
    libre = mkOption {
      type = bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    boot = {
      loader = {
        grub =
          let
            theme = pkgs.sleek-grub-theme.override {
              withBanner = "Hello Ivan";
              withStyle = "bigSur";
            };
          in
          {
            inherit theme;
            enable = pkgs.lib.mkDefault true;
            useOSProber = true;
            efiSupport = true;
            device = "nodev";
            splashImage = "${theme}/background.png";
          };
        efi.canTouchEfiVariables = true;
      };
      kernelPackages = mkDefault (if cfg.libre then pkgs.linuxPackages-libre else pkgs.linuxPackages);
    };
  };
}
