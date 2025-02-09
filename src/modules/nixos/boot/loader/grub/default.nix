{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.grubBoot;
in
{
  options.grubBoot = {
    enable = mkEnableOption "enable grub config";
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
      kernelPackages = pkgs.lib.mkDefault pkgs.stable.linuxPackages-libre;
    };
  };
}
