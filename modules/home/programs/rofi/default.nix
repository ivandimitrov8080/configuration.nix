{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override {
      plugins = with pkgs; [
        (
          rofi-calc.override
            {
              rofi-unwrapped = pkgs.rofi-wayland-unwrapped;
            }
        )
      ];
    };
    extraConfig = {
      modi = "window,drun,run,ssh,calc";
    };
  };
}
