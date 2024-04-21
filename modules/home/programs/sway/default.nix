{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = rec {
      menu = "rofi -show run";
      terminal = "kitty";
      modifier = "Mod4";
      startup = [
        { command = "swaymsg 'workspace 1; exec kitty'"; }
        { command = "swaymsg 'workspace 2; exec firefox'"; }
      ];
      bars = [ ];
      window.titlebar = false;
      keybindings = pkgs.lib.mkOptionDefault {
        "${modifier}+p" = "exec ${menu}";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+c" = "kill";
        "Alt+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock";
        "Alt+Shift+t" = "output 'eDP-1' toggle";
      };
      input = {
        "*" = {
          xkb_layout = "us,bg";
          xkb_options = "grp:win_space_toggle";
          xkb_variant = ",phonetic";
        };
      };
    };
    swaynag = {
      enable = true;
    };
  };
}
