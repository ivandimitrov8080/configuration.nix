{ moduleWithSystem, ... }: {
  flake.homeManagerModules = {
    dev = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        home.packages = with pkgs; [
          openssh
          procs
          ripgrep
          fswatch
          nvim
        ];
      }
    );
    essential = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        home.packages = with pkgs; [
          gopass
          ffmpeg
          transmission
          speedtest-cli
        ];
      }
    );
    random = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        home.packages = with pkgs; [
          xonotic
          tor-browser
        ];
      }
    );
    all = moduleWithSystem
      (
        top@{ ... }:
        perSystem@{ pkgs, ... }:
        rec {
          imports = [ ../programs ];
          programs.home-manager.enable = true;
          catppuccin = {
            enable = true;
            flavor = "mocha";
          };

          gtk = {
            enable = true;
          };

          home = rec {
            username = "ivand";
            homeDirectory = "/home/ivand";
            sessionPath = [
              "$HOME/.local/bin"
            ];
            sessionVariables = {
              PASSWORD_STORE_DIR = "${homeDirectory}/.password-store";
              EDITOR = "nvim";
              PAGER = "bat";
              TERM = "screen-256color";
              MAKEFLAGS = "-j 4";
            };
            pointerCursor = {
              name = "BreezeX-RosePine-Linux";
              package = pkgs.rose-pine-cursor;
              size = 24;
              gtk.enable = true;
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
            enable = true;
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
      );
    reminders =
      moduleWithSystem (
        top@{ ... }:
        perSystem@{ pkgs, ... }: {
          systemd.user = {
            timers = {
              track-time = {
                Timer = {
                  OnCalendar = "Mon..Fri *-*-* 16:00:*";
                  Persistent = true;
                };
                Install = {
                  WantedBy = [ "timers.target" ];
                };
              };
            };
            services = {
              track-time = {
                Service = {
                  Type = "oneshot";
                  ExecStart = [ "${pkgs.libnotify}/bin/notify-send -u critical 'Reminder: Track time'" ];
                };
              };
            };
          };
        }
      );
    cust = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        imports = [ ../programs/zsh ../programs/nushell ../programs/starship ../programs/carapace ../programs/bottom ../programs/firefox ];
        home.packages = with pkgs; [
          openssh
          procs
          ripgrep
          fswatch
        ];
      }
    );
  };
}
