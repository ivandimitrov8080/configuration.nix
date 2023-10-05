{ pkgs, lib, ... }: {

  imports = [ ./programs ./packages ];

  programs.home-manager = { enable = true; };

  home = {
    username = "ivand";
    homeDirectory = "/home/ivand";
    stateVersion = "23.11";
    pointerCursor = {
      name = "Catppuccin-Mocha-Green-Cursors";
      package = pkgs.catppuccin-cursors.mochaGreen;
    };
  };

  systemd.user = {
    timers = {
      bingwp = {
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };
    services = {
      bingwp = {
        Service = {
          Type = "oneshot";
          Environment = "PATH=${pkgs.nodejs_20}/bin";
          ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.bun}/bin/bunx bingwp'";
        };
      };
    };
  };

  xdg.configFile = {
    "user-dirs.dirs" = {
      text = ''
        XDG_DOCUMENTS_DIR="$HOME/doc"
        XDG_DOWNLOAD_DIR="$HOME/dl"
        XDG_PICTURES_DIR="$HOME/pic"
        XDG_VIDEOS_DIR="$HOME/vid"
      '';
    };
  };
}

