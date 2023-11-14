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
      bingwp = {
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
          Type = "oneshot";
          Environment = [ "PATH=${pkgs.curl}/bin:${pkgs.wget}/bin:${pkgs.xdg-user-dirs}/bin:${pkgs.jq}/bin:${pkgs.busybox}/bin:${pkgs.bash}/bin" ];
          ExecStart = [ "${pkgs.scripts}/bin/bingwp" ];
        };
      };
    };
  };

  programs = {
    nv.enable = true;
    shell.enable = true;
    common.enable = true;
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

