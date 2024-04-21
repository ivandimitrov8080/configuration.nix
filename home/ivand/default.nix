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
      wpd = {
        Service = {
          Environment = [
            "PATH=${pkgs.xdg-user-dirs}/bin:${pkgs.swaybg}/bin"
          ];
          ExecStart = [ "${pkgs.nushell}/bin/nu -c 'swaybg -i ((xdg-user-dir PICTURES) | path split | path join bg.png)'" ];
        };
      };
      bingwp = {
        Service = {
          Type = "oneshot";
          Environment = [
            "PATH=${pkgs.xdg-user-dirs}/bin:${pkgs.nushell}/bin"
          ];
          ExecStart = [ "${pkgs.scripts}/bin/bingwp" ];
        };
      };
      rbingwp = {
        Install = {
          WantedBy = [ "sway-session.target" ];
        };
        Unit = {
          Description = "Restart bingwp and wpd services";
          After = "graphical-session-pre.target";
          PartOf = "graphical-session.target";
        };
        Service = {
          Type = "oneshot";
          ExecStart = [ "${pkgs.nushell}/bin/nu -c '${pkgs.systemd}/bin/systemctl --user restart bingwp.service; ${pkgs.systemd}/bin/systemctl --user restart wpd.service'" ];
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

