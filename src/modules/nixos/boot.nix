{ pkgs, lib, ... }:
{
  boot = with lib; {
    loader = {
      grub =
        let
          theme = mkDefault pkgs.sleek-grub-theme.override {
            withBanner = "Hello Ivan";
            withStyle = "bigSur";
          };
        in
        {
          inherit theme;
          enable = mkDefault true;
          useOSProber = mkDefault true;
          efiSupport = mkDefault true;
          device = mkDefault "nodev";
          splashImage = mkDefault "${theme}/background.png";
        };
      efi.canTouchEfiVariables = mkDefault true;
    };
    kernelPackages = mkDefault pkgs.linuxPackages_latest-libre;
  };
}
