{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    catppuccin.enable = true;
    package = pkgs.rofi-wayland.override {
      plugins = with pkgs; [
        (
          rofi-calc.override
            {
              rofi-unwrapped = rofi-wayland-unwrapped;
            }
        )
      ];
    };
    extraConfig = {
      modi = "window,drun,run,ssh,calc";
    };
  };
}
