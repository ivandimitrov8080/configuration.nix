{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [ "sway/workspaces" ];
        modules-right = [ "memory" "battery" "clock" ];

        clock = {
          format = "{:%a %Y-%m-%d %H:%M:%S %Z}";
          interval = 1;
          timezones = [ "Europe/Sofia" "Europe/Prague" ];
          actions = {
            on-scroll-up = "tz_up";
            on-scroll-down = "tz_down";
          };
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
      };
    };
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };
}
