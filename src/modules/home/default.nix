top@{ moduleWithSystem, inputs, ... }:
{
  flake.homeManagerModules = {
    base = moduleWithSystem (
      _:
      { config, ... }:
      {
        programs.home-manager.enable = true;
        home.stateVersion = top.config.flake.stateVersion;
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
          mimeApps.enable = true;
        };
      }
    );
    ivand = moduleWithSystem (
      _:
      { pkgs, config, ... }:
      {
        home = {
          username = "ivand";
          homeDirectory = "/home/ivand";
          sessionVariables = {
            EDITOR = "nvim";
          };
          packages = with pkgs; [ nvim ];
          file = {
            ".w3m/config".text = ''
              inline_img_protocol 4
              imgdisplay kitty
              confirm_qq 0
              extbrowser ${pkgs.firefox}/bin/firefox
            '';
            ".w3m/keymap".text = ''
              keymap M EXTERN_LINK
            '';
          };
        };
        programs = {
          git = with pkgs.lib; {
            userName = mkForce "Ivan Kirilov Dimitrov";
            userEmail = mkForce "ivan@idimitrov.dev";
            signing = mkForce {
              signByDefault = true;
              key = "C565 2E79 2A7A 9110 DFA7  F77D 0BDA D4B2 11C4 9294";
            };
          };
          ssh = {
            matchBlocks = {
              vpsfree-ivand = {
                hostname = "10.0.0.1";
                user = "ivand";
              };
              vpsfree-root = {
                hostname = "10.0.0.1";
                user = "root";
              };
            };
          };
          neomutt = {
            enable = true;
            vimKeys = true;
            sidebar.enable = true;
            binds = [
              {
                map = [
                  "index"
                  "pager"
                ];
                key = "\\Cj";
                action = "sidebar-next";
              }
              {
                map = [
                  "index"
                  "pager"
                ];
                key = "\\Ck";
                action = "sidebar-prev";
              }
              {
                map = [
                  "index"
                  "pager"
                ];
                key = "\\Co";
                action = "sidebar-open";
              }
            ];
            macros =
              let
                unsetWait = "<enter-command> unset wait_key<enter>";
                findHtml = "<view-attachments><search>html<enter>";
                pipeLynx = "<pipe-message> ${pkgs.w3m}/bin/w3m -T text/html<enter>";
                setWait = "<enter-command> set wait_key<enter>";
                exit = "<exit>";
                archive = "s +Archive<enter>y$";
              in
              [
                {
                  map = [
                    "index"
                    "pager"
                  ];
                  key = "<Return>";
                  action = "${unsetWait}${findHtml}${pipeLynx}${setWait}${exit}";
                }
                {
                  map = [
                    "index"
                    "pager"
                  ];
                  key = "A";
                  action = "${archive}";
                }
              ];
            settings = {
              attach_save_dir = "${config.xdg.userDirs.download}";
              index_format = ''"%4C | %Z | %{%b %d} | %4c | %20.20L | %s"'';
            };
            extraConfig = # neomuttrc
              ''
                source ${pkgs.neomutt}/share/neomutt/colorschemes/vombatidae.neomuttrc
                color normal default default
                color index default default
                # Default index colors:
                color index color231 default ".*"
                color index_author color118 default ".*"
                color index_subject color124 default ".*"
                color index_size color33 default ".*"
                color index_date color208 default ".*"
                color index_flags color43 default ".*"
                color index_number blue default ".*"
                # New mail is boldened:
                color index color231 black "~N"
                color index_author color118 black "~N"
                color index_subject color124 black "~N"
                # Tagged mail is highlighted:
                color index color231 blue "~T"
                color index_author color118 blue "~T"
                color index_subject color124 blue "~T"
                # Flagged mail is highlighted:
                color index brightgreen default "~F"
                color index_subject brightgreen default "~F"
                color index_author brightgreen default "~F"
              '';
          };
          khal = {
            enable = true;
            package = pkgs.stable.khal;
            settings = {
              default = {
                default_calendar = "ivand";
                timedelta = "5d";
              };
              view = {
                agenda_event_format = "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
              };
            };
          };
          msmtp.enable = true;
          offlineimap.enable = true;
        };
        accounts = {
          calendar = {
            basePath = ".local/share/calendars";
            accounts.ivand = {
              primary = true;
              khal = {
                enable = true;
                color = "light green";
              };
            };
          };
          email = {
            maildirBasePath = "mail";
            accounts = {
              ivan = rec {
                primary = true;
                realName = "Ivan Kirilov Dimitrov";
                address = "ivan@idimitrov.dev";
                userName = address;
                passwordCommand = "pass vps/mail.idimitrov.dev/ivan@idimitrov.dev";
                msmtp = {
                  enable = true;
                  extraConfig = {
                    auth = "login";
                  };
                };
                signature = {
                  text = ''
                    Ivan Dimitrov
                    Software Developer
                    ivan@idimitrov.dev
                  '';
                };
                getmail = {
                  enable = true;
                  mailboxes = [ "ALL" ];
                };
                gpg = {
                  encryptByDefault = true;
                  signByDefault = true;
                };
                smtp = {
                  host = "idimitrov.dev";
                };
                imap = {
                  host = "idimitrov.dev";
                };
                neomutt = {
                  enable = true;
                  mailboxType = "imap";
                  extraMailboxes = [
                    "Sent"
                    "Drafts"
                    "Trash"
                    "Archive"
                  ];
                };
                offlineimap.enable = true;
              };
            };
          };
        };
      }
    );
    util = moduleWithSystem (
      _:
      { pkgs, config, ... }:
      {
        home = {
          packages = with pkgs; [
            openssl
            mlocate
            uutils-coreutils-noprefix
            speedtest-cli
            deadnix
            statix
          ];
          sessionVariables = {
            PAGER = "bat";
            BAT_THEME = "catppuccin-mocha";
          };
        };
        programs = {
          password-store = {
            enable = true;
            package = pkgs.pass.withExtensions (
              e: with e; [
                pass-otp
                pass-file
              ]
            );
            settings = {
              PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
            };
          };
          git = {
            enable = true;
            delta.enable = true;
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
              pa = "!git remote | xargs -L1 git push --all";
            };
          };
          tealdeer = {
            enable = true;
            settings = {
              display = {
                compact = true;
              };
              updates = {
                auto_update = true;
              };
            };
          };
          bottom = {
            enable = true;
            settings = {
              flags = {
                rate = "250ms";
              };
              row = [
                {
                  ratio = 40;
                  child = [
                    { type = "cpu"; }
                    { type = "mem"; }
                    { type = "net"; }
                  ];
                }
                {
                  ratio = 35;
                  child = [
                    { type = "temp"; }
                    { type = "disk"; }
                  ];
                }
                {
                  ratio = 40;
                  child = [
                    {
                      type = "proc";
                      default = true;
                    }
                  ];
                }
              ];
            };
          };
          fzf = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
          };
          nix-index = {
            enable = true;
            enableZshIntegration = false;
            enableBashIntegration = false;
          };
          bat = {
            enable = true;
            themes =
              let
                catppuccin = pkgs.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "bat";
                  rev = "82e7ca555f805b53d2b377390e4ab38c20282e83";
                  sha256 = "sha256-/Ob9iCVyjJDBCXlss9KwFQTuxybmSSzYRBZxOT10PZg=";
                };
              in
              {
                catppuccin-mocha = {
                  src = catppuccin;
                  file = "themes/Catppuccin Mocha.tmTheme";
                };
                catppuccin-macchiato = {
                  src = catppuccin;
                  file = "themes/Catppuccin Macchiato.tmTheme";
                };
                catppuccin-frappe = {
                  src = catppuccin;
                  file = "themes/Catppuccin Frappe.tmTheme";
                };
                catppuccin-latte = {
                  src = catppuccin;
                  file = "themes/Catppuccin Latte.tmTheme";
                };
              };
          };
          yazi = {
            enable = true;
          };
          fd.enable = true;
          ssh.enable = true;
          gpg.enable = true;
        };
        services = {
          gpg-agent = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            enableNushellIntegration = true;
            pinentryPackage = pkgs.pinentry-qt;
          };
        };
      }
    );
    shell = moduleWithSystem (
      _:
      { pkgs, ... }:
      {
        programs =
          let
            shellAliases = {
              cal = "cal $(date +%Y)";
              GG = "git add . && git commit -m 'GG' && git push --set-upstream origin HEAD";
              gad = "git add . && git diff --cached";
              gac = "ga && gc";
              ga = "git add .";
              gc = "git commit";
              dev = "nix develop --command $SHELL";
              ls = "eza";
              la = "eza --all -a";
              lt = "eza --git-ignore --all --tree --level=10";
              sc = "systemctl";
              neofetch = "${pkgs.fastfetch}/bin/fastfetch -c all.jsonc";
              opacity = "kitten @ set-background-opacity";
            };
            sessionVariables = { };
          in
          {
            bash = {
              inherit shellAliases sessionVariables;
              enable = true;
              enableVteIntegration = true;
              historyControl = [ "erasedups" ];
              historyIgnore = [
                "ls"
                "cd"
                "exit"
              ];
            };
            zsh = {
              inherit shellAliases sessionVariables;
              enable = true;
              dotDir = ".config/zsh";
              defaultKeymap = "viins";
              enableVteIntegration = true;
              syntaxHighlighting = {
                enable = true;
                highlighters = [
                  "main"
                  "brackets"
                  "cursor"
                  "root"
                  "line"
                ];
              };
              autosuggestion = {
                enable = true;
                highlight = "fg=cyan";
                strategy = [
                  "history"
                  "completion"
                  "match_prev_cmd"
                ];
              };
              history.expireDuplicatesFirst = true;
              historySubstringSearch.enable = true;
            };
            nushell = {
              enable = true;
              settings = {
                show_banner = false;
                completions.external = {
                  enable = true;
                  max_results = 250;
                };
              };
              shellAliases = pkgs.lib.mkForce {
                gcal = ''bash -c "cal $(date +%Y)" '';
                la = "ls -al";
                dev = "nix develop --command $env.SHELL";
                gd = "git diff --cached";
                ga = "git add .";
                gc = "git commit";
                cd = "z";
                cdi = "zi";
              };
              extraConfig = # nu
                ''
                  def gad [] {
                      git add .
                      git diff --cached
                  }
                  def gac [] {
                      git add .
                      git commit
                  }
                '';
            };
            kitty.shellIntegration = {
              enableBashIntegration = true;
              enableZshIntegration = true;
            };
            yazi = {
              enableBashIntegration = true;
              enableZshIntegration = true;
            };
            tmux = {
              enable = true;
              clock24 = true;
              baseIndex = 1;
              escapeTime = 0;
              keyMode = "vi";
              shell = "${pkgs.zsh}/bin/zsh";
              terminal = "screen-256color";
              plugins = with pkgs.tmuxPlugins; [
                tilish
                catppuccin
              ];
              extraConfig = ''
                set-option -a terminal-features 'screen-256color:RGB'
              '';
            };
            starship = {
              enable = true;
              enableNushellIntegration = true;
              enableZshIntegration = true;
              enableBashIntegration = true;
            };
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
                "--group-directories-first"
                "--octal-permissions"
                "--git"
              ];
            };
            zoxide = {
              enable = true;
              enableZshIntegration = true;
              enableBashIntegration = true;
            };
          };
      }
    );
    swayland = moduleWithSystem (
      _:
      { pkgs, config, ... }:
      {
        home = {
          packages = with pkgs; [
            audacity
            gimp
            grim
            libnotify
            libreoffice-qt
            mupdf
            slurp
            transmission_4
            wl-clipboard
            xdg-user-dirs
            xdg-utils
            telegram-desktop
            volume
          ];
          pointerCursor = {
            name = "phinger-cursors-light";
            package = pkgs.phinger-cursors;
          };
          sessionVariables = {
            WLR_RENDERER_ALLOW_SOFTWARE = 1;
          };
        };
        wayland.windowManager.sway = {
          enable = true;
          package = pkgs.swayfx;
          checkConfig = false;
          systemd.enable = true;
          wrapperFeatures.gtk = true;
          config = rec {
            menu = "rofi -show drun";
            terminal = "kitty";
            modifier = "Mod4";
            startup = [
              { command = "exec firefox"; }
              { command = "swaymsg 'workspace 1; exec kitty'"; }
            ];
            assigns = {
              "2" = [ { app_id = "^firefox$"; } ];
            };
            bars = [ ];
            gaps = {
              horizontal = 2;
              vertical = 2;
            };
            window = {
              titlebar = false;
              border = 0;
              commands = [
                {
                  command = "floating enable; move position center; resize set 30ppt 50ppt;";
                  criteria = {
                    title = "^calendar$";
                  };
                }
                {
                  command = "floating enable; move position center; resize set 70ppt 50ppt;";
                  criteria = {
                    title = "^mutt$";
                  };
                }
              ];
            };
            keybindings = pkgs.lib.mkOptionDefault {
              "XF86AudioMute" = "exec volume sink toggle";
              "Shift+XF86AudioMute" = "exec volume source toggle";
              "XF86AudioLowerVolume" = "exec volume sink down";
              "Shift+XF86AudioLowerVolume" = "exec volume source down";
              "XF86AudioRaiseVolume" = "exec volume sink up";
              "Shift+XF86AudioRaiseVolume" = "exec volume source up";
              "XF86MonBrightnessUp" = "exec sudo ${pkgs.brightnessctl}/bin/brightnessctl set 10%+";
              "XF86MonBrightnessDown" = "exec sudo ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
              "Alt+Shift+l" = "exec ${pkgs.gtklock}/bin/gtklock";
              "${modifier}+p" = "exec ${menu}";
              "${modifier}+Shift+s" = "exec ${pkgs.screenshot}/bin/screenshot screen";
              "${modifier}+Shift+a" = "exec ${pkgs.screenshot}/bin/screenshot area";
              "${modifier}+Shift+w" = "exec ${pkgs.screenshot}/bin/screenshot window";
              "${modifier}+c" = "exec kitty --title calendar -- ikhal";
              "${modifier}+m" = "exec kitty --title mutt -- neomutt";
              "End" = "exec rofi -show calc";
              "${modifier}+Shift+r" = "reload";
              "${modifier}+Shift+c" = "kill";
              "${modifier}+Shift+q" = "exec ${pkgs.procps}/bin/pkill -9 -u ${config.home.username}";
            };
            input = {
              "*" = {
                xkb_layout = "us,bg";
                xkb_options = "grp:win_space_toggle";
                xkb_variant = ",phonetic";
              };
            };
          };
          extraConfig = ''
            blur enable
            shadows enable
            corner_radius 15
            default_dim_inactive 0.5
            assign [class="^cs2$"] 4
          '';
          swaynag = { inherit (config.wayland.windowManager.sway) enable; };
        };
        programs = {
          waybar = {
            enable = true;
            settings = {
              mainBar = {
                layer = "top";
                position = "top";
                height = 30;
                output = [
                  "eDP-1"
                  "HDMI-A-1"
                  "*"
                ];
                modules-left = [
                  "sway/workspaces"
                  "sway/mode"
                ];
                modules-center = [
                  "clock#week"
                  "clock#year"
                  "clock#time"
                ];
                modules-right = [
                  "custom/weather"
                  "network"
                  "pulseaudio"
                  "battery"
                ];
                "clock#time" = {
                  interval = 1;
                  format = "{:%H:%M:%S}";
                  tooltip = false;
                };
                "clock#week" = {
                  format = "{:%a}";
                  tooltip = false;
                };
                "clock#year" = {
                  format = "{:%Y-%m-%d}";
                  tooltip = false;
                };
                battery = {
                  interval = 1;
                  format = "{icon} {capacity}% {time}";
                  format-time = " {H} h {M} m";
                  format-icons = [
                    ""
                    ""
                    ""
                    ""
                    ""
                  ];
                  states = {
                    warning = 30;
                    critical = 15;
                  };
                  tooltip = false;
                };
                pulseaudio = {
                  format = "<span color='#a6e3a1'>{icon}</span> {volume}% | {format_source}";
                  format-muted = "<span color='#f38ba8'>󰝟</span> {volume}% | {format_source}";
                  format-source = "{volume}% <span color='#a6e3a1'></span>";
                  format-source-muted = "{volume}% <span color='#f38ba8'></span>";
                  format-icons = {
                    headphone = "";
                    default = [
                      ""
                      ""
                      ""
                    ];
                  };
                  tooltip = false;
                };
                network = {
                  interval = 1;
                  format-ethernet = "<span color='#89dceb'>󰈁</span> Cable";
                  format-wifi = "<span color='#06b6d4'>{icon}</span> WiFi";
                  format-disconnected = "<span color='#eba0ac'>󰈂</span> Disconnected";
                  format-icons = [
                    "󰤟"
                    "󰤢"
                    "󰤥"
                    "󰤨"
                  ];
                  tooltip = false;
                };
                "custom/weather" = {
                  format = "{}°";
                  tooltip = true;
                  interval = 3600;
                  exec = "${pkgs.wttrbar}/bin/wttrbar --location Prague";
                  return-type = "json";
                };
                "sway/workspaces" = {
                  disable-scroll = true;
                  all-outputs = true;
                };
              };
            };
            systemd = {
              enable = true;
              target = "sway-session.target";
            };
            style = # css
              ''
                @import "${pkgs.themes-gtk}/mocha.css";
                * {
                    font-family: FontAwesome, 'Fira Code';
                    font-size: 13px;
                }

                window#waybar {
                    background-color: alpha(@base, 0.1);
                    border-bottom: 2px solid alpha(@sky, 0.5);
                    color: @rosewater;
                }

                #workspaces button {
                    padding: 0 5px;
                    background-color: alpha(@base, 0.85);
                    color: @text;
                    font-weight: 900;
                    border-radius: 6px;
                }

                #workspaces button:hover {
                    background: @mantle;
                }

                #workspaces button.focused {
                    background-color: alpha(@crust, 0.85);
                    box-shadow: inset 0 -2px @sky;
                }

                #workspaces button.urgent {
                    background-color: alpha(@red, 0.85);
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
                #mpd,
                #custom-weather {
                    padding: 0 1em;
                    color: @text;
                    font-weight: 900;
                    background-color: alpha(@base, 0.85);
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

                #battery.warning:not(.charging) {
                    background-color: alpha(@red, 0.85);
                    color: @crust;
                }

                /* Using steps() instead of linear as a timing function to limit cpu usage */
                #battery.critical:not(.charging) {
                    color: @crust;
                    animation-name: blink;
                    animation-duration: 1s;
                    animation-timing-function: steps(12);
                    animation-iteration-count: infinite;
                    animation-direction: alternate;
                }

                @keyframes blink {
                    0% { background-color: alpha(@mauve, 0.85); }
                    25% { background-color: alpha(@red, 0.85); }
                    50% { background-color: alpha(@maroon, 0.85); }
                    75% { background-color: alpha(@peach, 0.85); }
                    100% { background-color: alpha(@mauve, 0.85); }
                }
              '';
          };
          swaylock = {
            enable = true;
            settings = {
              show-failed-attempts = true;
              image = config.home.homeDirectory + "/.local/state/wpaperd/wallpapers/eDP-1";
            };
          };
          rofi = {
            enable = true;
            package = pkgs.rofi-wayland.override {
              plugins = with pkgs; [
                (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
              ];
            };
            extraConfig = {
              modi = "window,drun,run,ssh,calc";
              show-icons = true;
            };
            theme = "${pkgs.themes-rofi}/rounded-nord-dark.rasi";
          };
          kitty = {
            enable = true;
            font = {
              package = pkgs.fira-code;
              name = "FiraCodeNFM-Reg";
            };
            settings = {
              background_opacity = "0.80";
              background_blur = "1";
              cursor_shape = "beam";
              allow_remote_control = "yes";
              dynamic_background_opacity = "yes";
            };
            themeFile = "Catppuccin-Mocha";
          };
          imv = {
            enable = true;
            settings = {
              options.fullscreen = true;
            };
          };
          mpv = {
            enable = true;
            scripts =
              (with pkgs.mpvScripts; [
                uosc
                thumbfast
              ])
              ++ (with pkgs.fork.mpvScripts; [ skip-intro ]);
          };
          bash.profileExtra = ''[ "$(tty)" = "/dev/tty1" ] && exec sway '';
          zsh.loginExtra = ''[ "$(tty)" = "/dev/tty1" ] && exec sway '';
          nushell.loginFile.text = ''if (tty) == "/dev/tty1" { sway } '';
        };
        services = {
          wpaperd = {
            enable = true;
            settings = {
              default = {
                path = "${config.xdg.userDirs.pictures}/bg";
                duration = "10m";
              };
            };
          };
          mako = {
            enable = true;
            anchor = "bottom-right";
            backgroundColor = "#1E1E2EDD";
            borderRadius = 20;
          };
          cliphist.enable = true;
        };
        xdg.mimeApps.defaultApplications = {
          "image/jpg" = "imv.desktop";
          "image/jpeg" = "imv.desktop";
          "image/png" = "imv.desktop";
          "image/webp" = "imv.desktop";
          "image/gif" = "imv.desktop";
          "image/svg+xml" = "imv.desktop";
          "video/mp4" = "mpv.desktop";
          "video/mpeg" = "mpv.desktop";
          "video/ogg" = "mpv.desktop";
          "video/webm" = "mpv.desktop";
          "video/x-msvideo" = "mpv.desktop";
        };
      }
    );
    web = moduleWithSystem (
      _: _: {
        programs = {
          browserpass.enable = true;
          firefox = {
            enable = true;
            profiles.ivand = {
              id = 0;
              search = {
                default = "DuckDuckGo";
                privateDefault = "DuckDuckGo";
                force = true;
              };
              bookmarks = [
                {
                  name = "home-options";
                  url = "https://nix-community.github.io/home-manager/options.xhtml";
                }
                {
                  name = "nixvim-docs";
                  url = "https://nix-community.github.io/nixvim/";
                }
              ];
              settings = {
                "general.smoothScroll" = true;
                "signon.rememberSignons" = false;
                "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
                "layout.frame_rate" = 60;
                "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                "browser.newtabpage.activity-stream.telemetry" = false;
                "browser.ping-centre.telemetry" = false;
                "datareporting.healthreport.service.enabled" = false;
                "datareporting.healthreport.uploadEnabled" = false;
                "datareporting.policy.dataSubmissionEnabled" = false;
                "datareporting.sessions.current.clean" = true;
                "devtools.onboarding.telemetry.logged" = false;
                "toolkit.telemetry.archive.enabled" = false;
                "toolkit.telemetry.bhrPing.enabled" = false;
                "toolkit.telemetry.enabled" = false;
                "toolkit.telemetry.firstShutdownPing.enabled" = false;
                "toolkit.telemetry.hybridContent.enabled" = false;
                "toolkit.telemetry.newProfilePing.enabled" = false;
                "toolkit.telemetry.prompted" = 2;
                "toolkit.telemetry.rejected" = true;
                "toolkit.telemetry.reportingpolicy.firstRun" = false;
                "toolkit.telemetry.server" = "";
                "toolkit.telemetry.shutdownPingSender.enabled" = false;
                "toolkit.telemetry.unified" = false;
                "toolkit.telemetry.unifiedIsOptIn" = false;
                "toolkit.telemetry.updatePing.enabled" = false;
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
              NoDefaultBookmarks = true;
              PopupBlocking.Default = false;
              PromptForDownloadLocation = false;
              TranslateEnabled = false;
              SearchBar = "unified";
              SearchSuggestEnabled = false;
              SanitizeOnShutdown = {
                Cache = true;
                FormData = true;
                Locked = true;
                Cookies = false;
                Downloads = false;
                History = false;
                Sessions = false;
                SiteSettings = false;
                OfflineApps = true;
              };
              FirefoxHome = {
                Search = true;
                Pocket = false;
                Snippets = false;
                TopSites = false;
                Highlights = false;
              };
              UserMessaging = {
                ExtensionRecommendations = false;
                FeatureRecommendations = false;
                UrlbarInterventions = false;
                MoreFromMozilla = false;
                SkipOnboarding = true;
              };
              EnableTrackingProtection = {
                Value = true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
              };
              ExtensionSettings = {
                "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
                # uBlock Origin:
                "uBlock0@raymondhill.net" = {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                  installation_mode = "force_installed";
                };
                # Privacy Badger:
                "jid1-MnnxcxisBPnSXQ@jetpack" = {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
                  installation_mode = "force_installed";
                };
                # Browserpass:
                "browserpass@maximbaz.com" = {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/browserpass-ce/latest.xpi";
                  installation_mode = "force_installed";
                };
                # Vimium
                "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
                  installation_mode = "force_installed";
                };
                # Stylus
                "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/styl-us/latest.xpi";
                  installation_mode = "force_installed";
                };
              };

              Handlers = {
                schemes = {
                  mailto = {
                    action = "useHelperApp";
                    ask = false;
                    handlers = [
                      {
                        name = "RoundCube";
                        uriTemplate = "https://mail.idimitrov.dev/?_task=mail&_action=compose&_to=%s";
                      }
                    ];
                  };
                };
              };
            };
          };
          chromium = {
            enable = true;
          };
        };
        xdg.mimeApps.defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };
      }
    );
    reminders = moduleWithSystem (
      { ... }:
      { pkgs, lib, ... }:
      {
        systemd.user =
          let
            notify-send = lib.getExe pkgs.libnotify;
          in
          {
            timers = {
              do-ai = {
                Timer = {
                  OnCalendar = "Mon..Fri *-*-* 18:00:*";
                  Persistent = true;
                };
                Install = {
                  WantedBy = [ "timers.target" ];
                };
              };
            };
            services = {
              do-ai = {
                Service = {
                  Type = "oneshot";
                  ExecStart = [
                    "${notify-send} 'LEARN CHROME AI MOTHERFUCKER!!!' 'I AM NOT FUCKING KIDDING!!! If you dont then no point'"
                  ];
                };
              };
            };
          };
      }
    );
  };
}
