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
        programs = {
          git = {
            enable = true;
            delta.enable = true;
            userName = pkgs.lib.mkDefault "Ivan Kirilov Dimitrov";
            userEmail = pkgs.lib.mkDefault "ivan@idimitrov.dev";
            signing = {
              signByDefault = true;
              key = "ivan@idimitrov.dev";
            };
            extraConfig = {
              color.ui = "auto";
              pull.rebase = true;
              push.autoSetupRemote = true;
            };
            aliases = {
              a = "add .";
              c = "commit";
              d = "diff --cached";
              p = "push";
            };
          };
        };
        services.pueue.enable = true;
      }
    );
    shell = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        programs = {
          zsh = {
            enable = true;
            dotDir = ".config/zsh";
            defaultKeymap = "viins";
            enableVteIntegration = true;
            syntaxHighlighting.enable = true;
            autosuggestion.enable = true;
            loginExtra = ''
              [ "$(tty)" = "/dev/tty1" ] && exec sway
            '';
            sessionVariables = {
              TERM = "screen-256color";
            };
            shellAliases = {
              cal = "cal $(date +%Y)";
              GG = "git add . && git commit -m 'GG' && git push --set-upstream origin HEAD";
              gad = "git add . && git diff --cached";
              gac = "ga && gc";
              gach = "gac -C HEAD";
              ga = "git add .";
              gc = "git commit";
              dev = "nix develop --command $SHELL";
              ls = "${pkgs.nushell}/bin/nu -c 'ls'";
              la = "${pkgs.nushell}/bin/nu -c 'ls -al'";
              torrent = "transmission-remote";
              vi = "nvim";
              sc = "systemctl";
            };
            shellGlobalAliases.comp = "-vcodec libx265 -crf 28";
            history.expireDuplicatesFirst = true;
            historySubstringSearch.enable = true;
          };
          tmux = {
            enable = true;
            clock24 = true;
            baseIndex = 1;
            escapeTime = 0;
            keyMode = "vi";
            shell = "\${SHELL}";
            terminal = "screen-256color";
            plugins = with pkgs.tmuxPlugins; [ tilish catppuccin ];
            extraConfig = ''
              set-option -a terminal-features 'screen-256color:RGB'
            '';
          };
          nushell = {
            enable = true;
            environmentVariables = {
              config = ''
                {
                  show_banner: false,
                  completions: {
                    quick: false
                    partial: false
                    algorithm: "prefix"
                  }
                }
              '';
              PATH = "($env.PATH | split row (char esep) | append ($env.HOME | path join .local bin))";
            };
            shellAliases = {
              gcal = ''
                bash -c "cal $(date +%Y)"
              '';
              la = "ls -al";
              dev = "nix develop --command $env.SHELL";
              torrent = "transmission-remote";
              vi = "nvim";
              sc = "systemctl";
              neofetch = "${pkgs.fastfetch}/bin/fastfetch -c all.jsonc";
            };
            loginFile.text = ''
              if (tty) == "/dev/tty1" {
                sway
              }
            '';
          };
          starship = {
            enable = true;
            enableNushellIntegration = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
          };
        };
        services.pueue.enable = true;
      }
    );
    base = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        programs.home-manager.enable = true;
        home.packages = with pkgs; [
          gopass
          ffmpeg
          transmission_4
          speedtest-cli
        ];
        bat = {
          enable = true;
        };
      }
    );
    random = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        home.packages = with pkgs; [
          xonotic
          tor-browser
          electrum
          bisq-desktop
        ];
      }
    );
    sway = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
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
          slurp
          wl-clipboard
          xdg-user-dirs
          xdg-utils
          xwayland
        ];
      }
    );
    all = moduleWithSystem
      (
        top@{ ... }:
        perSystem@{ pkgs, ... }:
        rec {
          imports = [ ../programs ];

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
            pointerCursor = with pkgs; {
              name = lib.mkForce "BreezeX-RosePine-Linux";
              package = lib.mkForce rose-pine-cursor;
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
