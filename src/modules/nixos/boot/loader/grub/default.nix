{ pkgs, ... }:
{
  boot = {
    plymouth = {
      enable = true;
      themePackages = [ pkgs.themes-plymouth ];
      theme = "catppuccin-mocha";
    };
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
}
