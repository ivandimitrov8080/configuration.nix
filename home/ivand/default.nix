{ pkgs, lib, ... }: rec {

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
            "PATH=${pkgs.curl}/bin:${pkgs.wget}/bin:${pkgs.xdg-user-dirs}/bin:${pkgs.jq}/bin:${pkgs.toybox}/bin:${pkgs.bash}/bin:${pkgs.swaybg}/bin"
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

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${home.homeDirectory}/dt";
      documents = "${home.homeDirectory}/doc";
      download = "${home.homeDirectory}/dl";
      pictures = "${home.homeDirectory}/pic";
      videos = "${home.homeDirectory}/vid";
      templates = "${home.homeDirectory}/tpl";
      publicShare = "${home.homeDirectory}/pub";
      music = "${home.homeDirectory}/mus";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "x-scheme-handler/mailto" = "userapp-Thunderbird-LDALA2.desktop";
        "message/rfc822" = "userapp-Thunderbird-LDALA2.desktop";
        "x-scheme-handler/mid" = "userapp-Thunderbird-LDALA2.desktop";
      };
    };
  };
}

