toplevel@{ moduleWithSystem, ... }: {
  flake.homeManagerModules = {
    base = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, config, ... }: {
        programs.home-manager.enable = true;
        home = {
          stateVersion = toplevel.config.flake.stateVersion;
          username = "ivand";
          homeDirectory = "/home/ivand";
          sessionVariables = {
            EDITOR = "nvim";
            PAGER = "bat";
            TERM = "screen-256color";
            MAKEFLAGS = "-j 4";
          };
          pointerCursor = with pkgs; { name = "catppuccin-mocha-green-cursors"; package = catppuccin-cursors.mochaGreen; size = 24; gtk.enable = true; };
          packages = with pkgs; [ transmission_4 speedtest-cli nvim ];
        };
        xdg = {
          enable = true;
          userDirs = with config; {
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
            };
          };
        };
      }
    );
    ivand = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, config, ... }: {
        programs = {
          password-store = { enable = true; package = pkgs.pass.withExtensions (e: with e; [ pass-otp pass-file ]); settings = { PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store"; }; };
          git = {
            enable = true;
            delta.enable = true;
            userName = pkgs.lib.mkDefault "Ivan Kirilov Dimitrov";
            userEmail = pkgs.lib.mkDefault "ivan@idimitrov.dev";
            signing = { signByDefault = true; key = "ivan@idimitrov.dev"; };
            extraConfig = { color.ui = "auto"; pull.rebase = true; push.autoSetupRemote = true; };
            aliases = { a = "add ."; c = "commit"; d = "diff --cached"; p = "push"; pa = "!git remote | xargs -L1 git push --all"; };
          };
          ssh = {
            enable = true;
            matchBlocks = {
              vpsfree = {
                hostname = "37.205.13.29";
                user = "ivand";
              };
              vpsfree-root = {
                hostname = "37.205.13.29";
                user = "root";
              };
            };
          };
          gpg.enable = true;
        };
        services = { gpg-agent = { enable = true; enableBashIntegration = true; enableZshIntegration = true; enableNushellIntegration = true; pinentryPackage = pkgs.pinentry-qt; }; };
      }
    );
    shell = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        programs =
          let
            shellAliases = {
              cal = "cal $(date +%Y)";
              GG = "git add . && git commit -m 'GG' && git push --set-upstream origin HEAD";
              gad = "git add . && git diff --cached";
              gac = "ga && gc";
              gach = "gac -C HEAD";
              ga = "git add .";
              gc = "git commit";
              dev = "nix develop --command $SHELL";
              ls = "eza";
              la = "eza --all";
              lt = "eza --git-ignore --all --tree --level=10";
              torrent = "transmission-remote";
              torrent-start = "transmission-daemon";
              vi = "nvim";
              sc = "systemctl";
              neofetch = "${pkgs.fastfetch}/bin/fastfetch -c all.jsonc";
            };
            sessionVariables = { TERM = "screen-256color"; };
          in
          {
            bash = {
              inherit shellAliases sessionVariables;
              enable = true;
              enableVteIntegration = true;
              historyControl = [ "erasedups" ];
              historyIgnore = [ "ls" "cd" "exit" ];
            };
            zsh = {
              inherit shellAliases sessionVariables;
              enable = true;
              dotDir = ".config/zsh";
              defaultKeymap = "viins";
              enableVteIntegration = true;
              syntaxHighlighting.enable = true;
              autosuggestion.enable = true;
              history.expireDuplicatesFirst = true;
              historySubstringSearch.enable = true;
            };
            nushell = {
              enable = true;
              environmentVariables = { config = '' { show_banner: false, completions: { quick: false partial: false algorithm: "prefix" } } ''; };
              shellAliases = { gcal = '' bash -c "cal $(date +%Y)" ''; la = "ls -al"; dev = "nix develop --command $env.SHELL"; };
            };
            kitty.shellIntegration = { enableBashIntegration = true; enableZshIntegration = true; };
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
            starship = { enable = true; enableNushellIntegration = true; enableZshIntegration = true; enableBashIntegration = true; };
            eza = {
              enable = true;
              enableZshIntegration = true;
              enableBashIntegration = true;
              extraOptions = [
                "--long"
                "--header"
                "--icons"
                "--smart-group"
                "--mounts"
                "--octal-permissions"
                "--git"
              ];
            };
          };
      }
    );
    util = moduleWithSystem (
      top@{ ... }:
      perSystem@{ ... }: {
        programs = {
          tealdeer = {
            enable = true;
            settings = { display = { compact = true; }; updates = { auto_update = true; }; };
          };
          bottom = {
            enable = true;
            settings = {
              flags = { rate = "250ms"; };
              row = [
                { ratio = 40; child = [{ type = "cpu"; } { type = "mem"; } { type = "net"; }]; }
                { ratio = 35; child = [{ type = "temp"; } { type = "disk"; }]; }
                { ratio = 40; child = [{ type = "proc"; default = true; }]; }
              ];
            };
          };
          bat.enable = true;
        };
      }
    );
    swayland = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, config, ... }: {
        wayland.windowManager.sway = {
          enable = true;
          systemd.enable = true;
          config = rec {
            menu = "rofi -show run";
            terminal = "kitty";
            modifier = "Mod4";
            startup = [
              { command = "swaymsg 'workspace 2; exec firefox'"; }
              { command = "swaymsg 'workspace 1; exec kitty'"; }
            ];
            bars = [ ];
            window.titlebar = false;
            keybindings = pkgs.lib.mkOptionDefault {
              "F1" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "Shift+F1" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
              "F2" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "Shift+F2" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -5%";
              "F3" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "Shift+F3" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +5%";
              "F9" = "exec doas ${pkgs.light}/bin/light -A 10";
              "F8" = "exec doas ${pkgs.light}/bin/light -U 10";
              "Alt+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock";
              "${modifier}+p" = "exec ${menu}";
              "${modifier}+Shift+a" = "exec ${pkgs.screenshot}/bin/screenshot area";
              "${modifier}+Shift+s" = "exec ${pkgs.screenshot}/bin/screenshot";
              "${modifier}+c" = "exec ${pkgs.sal}/bin/sal";
              "End" = "exec rofi -show calc";
              "${modifier}+Shift+r" = "reload";
              "${modifier}+Shift+c" = "kill";
              "${modifier}+Shift+q" = "exit";
            };
            input = { "*" = { xkb_layout = "us,bg"; xkb_options = "grp:win_space_toggle"; xkb_variant = ",phonetic"; }; };
          };
          swaynag = { enable = config.wayland.windowManager.sway.enable; };
        };
        programs = {
          waybar = {
            enable = true;
            settings = {
              mainBar =
                let
                in
                {
                  layer = "top";
                  position = "top";
                  height = 30;
                  output = [ "eDP-1" "HDMI-A-1" ];

                  modules-left = [ "sway/workspaces" ];
                  modules-center = [ "clock#week" "clock#year" "clock#time" ];
                  modules-right = [ "network" "pulseaudio" "memory" "cpu" "battery" ];

                  "clock#time" = { format = "{:%H:%M:%S}"; interval = 1; };
                  "clock#week" = { format = "{:%a}"; };
                  "clock#year" = { format = "{:%Y-%m-%d}"; };

                  battery = {
                    format = "{icon} <span color='#cdd6f4'>{capacity}% {time}</span>";
                    format-time = " {H} h {M} m";
                    format-icons = [ "" "" "" "" "" ];
                    states = { warning = 30; critical = 15; };
                    tooltip = false;
                  };

                  cpu = { format = "<span color='#74c7ec'></span>  {usage}%"; };

                  memory = { format = "<span color='#89b4fa'></span>  {percentage}%"; interval = 5; };

                  pulseaudio = {
                    format = "<span color='#a6e3a1'>{icon}</span> {volume}% | {format_source}";
                    format-muted = "<span color='#f38ba8'>󰝟</span> {volume}% | {format_source}";
                    format-source = "{volume}% <span color='#a6e3a1'></span>";
                    format-source-muted = "{volume}% <span color='#f38ba8'></span>";
                    format-icons = { headphone = ""; default = [ "" "" "" ]; };
                    tooltip = false;
                  };

                  network = {
                    format-ethernet = "<span color='#89dceb'>󰈁</span> | <span color='#fab387'></span> {bandwidthUpBytes}  <span color='#fab387'></span> {bandwidthDownBytes}";
                    format-wifi = "<span color='#06b6d4'>{icon}</span> | <span color='#fab387'></span> {bandwidthUpBytes}  <span color='#fab387'></span> {bandwidthDownBytes}";
                    format-disconnected = "<span color='#eba0ac'>󰈂 no connection</span>";
                    format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
                    interval = 5;
                    tooltip = false;
                  };

                  "sway/workspaces" = { disable-scroll = true; all-outputs = true; };
                };
            };
            systemd = { enable = true; target = "sway-session.target"; };
            style = /* CSS */
              ''
                @define-color rosewater #f5e0dc;
                @define-color flamingo #f2cdcd;
                @define-color pink #f5c2e7;
                @define-color mauve #cba6f7;
                @define-color red #f38ba8;
                @define-color maroon #eba0ac;
                @define-color peach #fab387;
                @define-color yellow #f9e2af;
                @define-color green #a6e3a1;
                @define-color teal #94e2d5;
                @define-color sky #89dceb;
                @define-color sapphire #74c7ec;
                @define-color blue #89b4fa;
                @define-color lavender #b4befe;
                @define-color text #cdd6f4;
                @define-color subtext1 #bac2de;
                @define-color subtext0 #a6adc8;
                @define-color overlay2 #9399b2;
                @define-color overlay1 #7f849c;
                @define-color overlay0 #6c7086;
                @define-color surface2 #585b70;
                @define-color surface1 #45475a;
                @define-color surface0 #313244;
                @define-color base #1e1e2e;
                @define-color mantle #181825;
                @define-color crust #11111b;
                * {
                    font-family: FontAwesome, 'Fira Code';
                    font-size: 13px;
                }

                window#waybar {
                    background-color: rgba(43, 48, 59, 0.1);
                    border-bottom: 2px solid rgba(100, 114, 125, 0.5);
                    color: @rosewater;
                }

                #workspaces button {
                    padding: 0 5px;
                    background-color: @base;
                    color: @text;
                    border-radius: 6px;
                }

                #workspaces button:hover {
                    background: @mantle;
                }

                #workspaces button.focused {
                    background-color: @crust;
                    box-shadow: inset 0 -2px @sky;
                }

                #workspaces button.urgent {
                    background-color: @red;
                }

                #clock,
                #battery,
                #cpu,
                #memory,
                #disk,
                #temperature,
                #backlight,
                #network,
                #pulseaudio,
                #wireplumber,
                #custom-media,
                #tray,
                #mode,
                #idle_inhibitor,
                #scratchpad,
                #power-profiles-daemon,
                #mpd {
                    padding: 0 10px;
                    color: @text;
                    background-color: @base;
                    margin: 0 .5em;
                    border-radius: 9999px;
                }

                #clock.week {
                  margin-right: 0px;
                  color: @peach;
                  border-radius: 9999px 0px 0px 9999px;
                }

                #clock.year {
                  margin: 0px;
                  padding: 0px;
                  color: @pink;
                  border-radius: 0px;
                }

                #clock.time {
                  margin-left: 0px;
                  color: @sky;
                  border-radius: 0px 9999px 9999px 0px;
                }

                #battery.charging, #battery.plugged {
                    color: @green;
                }

                #battery.discharging {
                    color: @yellow;
                }

                @keyframes blink {
                    to {
                        background-color: #ffffff;
                        color: #000000;
                    }
                }

                #battery.warning:not(.charging) {
                    background-color: @red;
                }

                /* Using steps() instead of linear as a timing function to limit cpu usage */
                #battery.critical:not(.charging) {
                    background-color: @red;
                    animation-name: blink;
                    animation-duration: 0.5s;
                    animation-timing-function: steps(12);
                    animation-iteration-count: infinite;
                    animation-direction: alternate;
                }
              ''
            ;
          };
          swaylock = {
            enable = true;
            settings = { show-failed-attempts = true; image = config.home.homeDirectory + "/pic/bg.png"; };
          };
          rofi = {
            enable = true;
            package = pkgs.rofi-wayland.override {
              plugins = with pkgs; [
                (
                  rofi-calc.override
                    {
                      rofi-unwrapped = rofi-wayland-unwrapped;
                    }
                )
              ];
            };
            extraConfig = {
              modi = "window,drun,run,ssh,calc";
            };
          };
          kitty = {
            enable = true;
            font = { package = pkgs.fira-code; name = "FiraCodeNFM-Reg"; };
            settings = { background_opacity = "0.90"; cursor_shape = "beam"; term = "screen-256color"; };
          };
          imv.enable = true;
          mpv.enable = true;
          bash.profileExtra = '' [ "$(tty)" = "/dev/tty1" ] && exec sway '';
          zsh.loginExtra = '' [ "$(tty)" = "/dev/tty1" ] && exec sway '';
          nushell.loginFile.text = '' if (tty) == "/dev/tty1" { sway } '';
        };
        services = { mako.enable = true; cliphist = { enable = true; systemdTarget = "sway-session.target"; }; };
        systemd.user = {
          timers = { rbingwp = { Timer = { OnCalendar = "*-*-* 10:00:00"; Persistent = true; }; Install = { WantedBy = [ "timers.target" ]; }; }; };
          services = {
            wpd = {
              Service = {
                Environment = [ "PATH=${pkgs.xdg-user-dirs}/bin:${pkgs.swaybg}/bin" ];
                ExecStart = [ "${pkgs.nushell}/bin/nu -c 'swaybg -i ((xdg-user-dir PICTURES) | path split | path join bg.png)'" ];
              };
            };
            bingwp = {
              Service = { Type = "oneshot"; Environment = [ "PATH=${pkgs.xdg-user-dirs}/bin:${pkgs.nushell}/bin" ]; ExecStart = [ "${pkgs.bingwp}/bin/bingwp" ]; };
            };
            rbingwp = {
              Install = { WantedBy = [ "sway-session.target" ]; };
              Unit = { Description = "Restart bingwp and wpd services"; After = "graphical-session-pre.target"; PartOf = "graphical-session.target"; };
              Service = {
                Type = "oneshot";
                ExecStart = [ "${pkgs.nushell}/bin/nu -c '${pkgs.systemd}/bin/systemctl --user restart bingwp.service; ${pkgs.systemd}/bin/systemctl --user restart wpd.service'" ];
              };
            };
          };
        };
        home.packages = with pkgs; [ audacity gimp grim libnotify libreoffice-qt mupdf slurp wl-clipboard xdg-user-dirs xdg-utils xwayland ];
      }
    );
    web = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        programs = {
          browserpass.enable = true;
          firefox = {
            enable = true;
            profiles.ivand = {
              id = 0;
              search.default = "DuckDuckGo";
              bookmarks = [
                { name = "home-options"; url = "https://nix-community.github.io/home-manager/options.xhtml"; }
                { name = "nixvim-docs"; url = "https://nix-community.github.io/nixvim/"; }
              ];
              settings = {
                "general.smoothScroll" = true;
                "signon.rememberSignons" = false;
                "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
                "layout.frame_rate" = 120;
              };
            };
            policies = {
              CaptivePortal = false;
              DisableFirefoxStudies = true;
              DisablePocket = true;
              DisableTelemetry = true;
              DisableFirefoxAccounts = true;
              OfferToSaveLogins = false;
              OfferToSaveLoginsDefault = false;
              PasswordManagerEnabled = false;

              FirefoxHome = { Search = true; Pocket = false; Snippets = false; TopSites = false; Highlights = false; };

              UserMessaging = { ExtensionRecommendations = false; SkipOnboarding = true; };

              Handlers = {
                schemes = {
                  mailto = { action = "useHelperApp"; ask = false; handlers = [{ name = "RoundCube"; uriTemplate = "https://mail.idimitrov.dev/?_task=mail&_action=compose&_to=%s"; }]; };
                };
              };
            };
          };
        };
        home = {
          file.".mozilla/native-messaging-hosts/gpgmejson.json".text = builtins.toJSON {
            name = "gpgmejson";
            description = "Integration with GnuPG";
            path = "${pkgs.gpgme.dev}/bin/gpgme-json";
            type = "stdio";
            allowed_extensions = [ "jid1-AQqSMBYb0a8ADg@jetpack" ];
          };
        };
      }
    );
    work = moduleWithSystem (
      top@{ ... }:
      perSystem@{ pkgs, ... }: {
        programs.chromium = { enable = true; package = pkgs.ungoogled-chromium; };
      }
    );
  };
}
