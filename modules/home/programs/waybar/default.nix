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
          format = "{:%a %Y-%m-%d %H:%M:%S}";
          interval = 1;
          timezones = [ "Europe/Sofia" "Europe/Prague" ];
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
      };
    };
  };
}
