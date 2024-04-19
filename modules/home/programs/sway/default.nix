{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = null;
    extraConfig = builtins.readFile ./config;
  };
}
