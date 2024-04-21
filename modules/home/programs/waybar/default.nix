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
        modules-right = [ "pulseaudio" "memory" "battery" "clock" ];

        clock = {
          format = "{:%a %Y-%m-%d %H:%M:%S %Z}";
          interval = 1;
          timezones = [ "Europe/Sofia" "Europe/Prague" ];
          actions = {
            on-scroll-up = "tz_up";
            on-scroll-down = "tz_down";
          };
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        memory = {
          format = " {percentage}%";
          interval = 5;
        };

        pulseaudio = {
          format = "{icon} {volume}% | {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-muted = "";
          format-icons = {
            headphone = "";
            default = [ "" "" ];
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
