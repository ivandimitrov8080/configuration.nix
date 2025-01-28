{ pkgs, ... }:
{
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
    kernelPackages = pkgs.lib.mkDefault pkgs.linuxPackages-libre;
  };
}
