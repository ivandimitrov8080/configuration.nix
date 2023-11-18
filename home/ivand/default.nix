{ pkgs, lib, ... }: {

  programs.home-manager = { enable = true; };

  home = {
    username = "ivand";
    homeDirectory = "/home/ivand";
    stateVersion = "23.11";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    pointerCursor = {
      name = "Catppuccin-Mocha-Green-Cursors";
      package = pkgs.catppuccin-cursors.mochaGreen;
    };
  };

  systemd.user = {
    timers = {
      rbingwp = {
        Timer = {
          OnCalendar = "*-*-* 10:00:00";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
    services = {
      bingwp = {
        Service = {
          Environment = [
            "PATH=${pkgs.curl}/bin:${pkgs.wget}/bin:${pkgs.xdg-user-dirs}/bin:${pkgs.jq}/bin:${pkgs.busybox}/bin:${pkgs.bash}/bin:${pkgs.swaybg}/bin"
            "WAYLAND_DISPLAY=wayland-1"
          ];
          ExecStart = [ "${pkgs.scripts}/bin/bingwp" ];
        };
      };
      rbingwp = {
        Service = {
          Type = "oneshot";
          ExecStart = [ "${pkgs.systemd}/bin/systemctl --user restart bingwp.service" ];
        };
      };
    };
  };

  xdg.configFile = {
    "user-dirs.dirs" = {
      text = ''
        XDG_DOWNLOAD_DIR="$HOME/dl"
        XDG_DOCUMENTS_DIR="$HOME/doc"
        XDG_PICTURES_DIR="$HOME/pic"
        XDG_VIDEOS_DIR="$HOME/vid"
      '';
    };
  };
}

