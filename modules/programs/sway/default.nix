{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = builtins.readFile ./config;
  };
}
