{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar =
        let
        in
        {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "eDP-1"
            "HDMI-A-1"
          ];
          modules-left = [ "sway/workspaces" ];
          modules-center = [ "clock#week" "clock#year" "clock#time" ];
          modules-right = [ "network" "pulseaudio" "memory" "cpu" "battery" ];

          "clock#time" = {
            format = "{:%H:%M:%S}";
            interval = 1;
          };

          "clock#week" = {
            format = "{:%a}";
          };

          "clock#year" = {
            format = "{:%Y-%m-%d}";
          };

          battery = {
            format = "{icon} <span color='#cdd6f4'>{capacity}% {time}</span>";
            format-time = " {H} h {M} m";
            format-icons = [ "" "" "" "" "" ];
            states = {
              warning = 30;
              critical = 15;
            };
          };

          cpu = {
            format = "<span color='#74c7ec'></span>  {usage}%";
          };

          memory = {
            format = "<span color='#89b4fa'></span>  {percentage}%";
            interval = 5;
          };

          pulseaudio = {
            format = "<span color='#a6e3a1'>{icon}</span> {volume}% | {format_source}";
            format-muted = "<span color='#f38ba8'>󰝟</span> {volume}% | {format_source}";
            format-source = "{volume}% <span color='#a6e3a1'></span>";
            format-source-muted = "{volume}% <span color='#f38ba8'></span>";
            format-icons = {
              headphone = "";
              default = [ "" "" "" ];
            };
          };

          network = {
            format-ethernet = "<span color='#89dceb'>󰈁</span> | <span color='#fab387'></span> {bandwidthUpBytes}  <span color='#fab387'></span> {bandwidthDownBytes}";
            format-wifi = "<span color='#06b6d4'>{icon}</span> | <span color='#fab387'></span> {bandwidthUpBytes}  <span color='#fab387'></span> {bandwidthDownBytes}";
            format-disconnected = "<span color='#eba0ac'>󰈂 no connection</span>";
            format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
            interval = 5;
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
    style = builtins.readFile ./style.css;
  };
}
