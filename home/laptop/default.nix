{ pkgs, lib, ... }: {

  imports = [ ./programs ./packages ];

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
          OnCalendar = "daily";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
    services = {
      bingwp = {
        Unit = {
          Type = "oneshot";
        };
        Service = {
          Environment = [ "PATH=${pkgs.nodejs_20}/bin" ];
          ExecStart = [ "${pkgs.bash}/bin/bash -c '${pkgs.bun}/bin/bunx bingwp'" ];
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

