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

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${home.homeDirectory}/dt";
      documents = "${home.homeDirectory}/doc";
      download = "${home.homeDirectory}/dl";
      pictures = "${home.homeDirectory}/pic";
      videos = "${home.homeDirectory}/vid";
      templates = "${home.homeDirectory}/templates";
      publicShare = "${home.homeDirectory}/pub";
      music = "${home.homeDirectory}/mus";
    };
  };
}

