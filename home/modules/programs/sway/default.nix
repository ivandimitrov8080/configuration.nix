{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    catppuccin.enable = true;
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
        # Audio
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "Alt+XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%";
        "Alt+XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        # Display
        "Alt+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock"; # Lock screen
        "XF86ScreenSaver" = "output 'eDP-1' toggle"; # Turn screen off
        "XF86MonBrightnessUp" = "exec doas ${pkgs.light}/bin/light -A 10";
        "XF86MonBrightnessDown" = "exec doas ${pkgs.light}/bin/light -U 10";
        # Programs
        "${modifier}+p" = "exec ${menu}";
        "${modifier}+Shift+a" = "exec screenshot area";
        "${modifier}+Shift+s" = "exec screenshot";
        "${modifier}+c" = "exec ${pkgs.sal}/bin/sal";
        "End" = "exec rofi -show calc";
        # sway commands
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Shift+q" = "exit";
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
  home.packages = with pkgs; [
    audacity
    gimp
    grim
    libnotify
    libreoffice-qt
    mupdf
    pavucontrol
    slurp
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    xwayland
  ];
}
