{ pkgs, ... }:
{
  boot = {
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        adi1090x-plymouth-themes
      ];
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
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
