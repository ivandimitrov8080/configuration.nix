{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (import ../../lib { inherit lib; }) mkDefaultAttrs;
  shellAliases = {
    sc = "systemctl";
    flip = "shuf -r -n 1 -e Heads Tails";
  }
  // (
    if config.programs.eza.enable then
      {
        ls = "eza";
        la = "eza --all -a";
        lt = "eza --git-ignore --all --tree --level=10";
      }
    else
      { }
  )
  // (
    if config.programs.zoxide.enable then
      {
        cd = "z";
        cdi = "zi";
      }
    else
      { }
  );
in
mkDefaultAttrs {
  xdg = {
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
    mimeApps.defaultApplications = {
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
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
  home = {
    stateVersion = "25.11";
    shell.enableShellIntegration = true;
    sessionVariables = {
      PAGER = "bat";
      EDITOR = "nvim";
      WLR_RENDERER_ALLOW_SOFTWARE = 1;
      BAT_THEME = "catppuccin-mocha";
    };
  };
  programs = {
    home-manager.enable = true;
    ssh = {
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
      };
    };
    msmtp.enable = false;
    offlineimap.enable = false;
    password-store = {
      enable = false;
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
      signing.signByDefault = true;
      settings = {
        alias = {
          a = "add .";
          c = "commit";
          d = "diff --cached";
          p = "push";
          pa = "!git remote | xargs -L1 git push --all";
          co = "checkout";
        };
        color.ui = "auto";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
    delta.enableGitIntegration = true;
    gh = {
      settings = {
        git_protocol = "ssh";
        prefer_editor_prompt = "enabled";
        color_labels = "enabled";
        aliases = { };
      };
    };
    tealdeer = {
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
    bat = {
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
    bash = {
      shellAliases = shellAliases;
      enableVteIntegration = true;
      historyControl = [ "erasedups" ];
      historyIgnore = [
        "ls"
        "cd"
        "exit"
      ];
      initExtra = "set -o vi";
    };
    zsh = {
      shellAliases = shellAliases;
      defaultKeymap = "viins";
      enableVteIntegration = true;
      dotDir = "${config.xdg.configHome}/zsh";
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "cursor"
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
      settings = {
        show_banner = false;
        completions.external = {
          enable = true;
          max_results = 250;
        };
      };
      shellAliases = (builtins.removeAttrs shellAliases [ "ls" ]) // {
        la = "ls -al";
      };
    };
    tmux = {
      clock24 = true;
      baseIndex = 1;
      escapeTime = 0;
      keyMode = "vi";
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        tilish
        catppuccin
      ];
      extraConfig = ''
        set-option -a terminal-features 'screen-256color:RGB'
        set -s copy-command 'wl-copy'
        set -g default-command "''${SHELL}"
      '';
    };
    eza = {
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
    waybar = {
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
            "wireplumber#sink"
            "wireplumber#source"
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
          "wireplumber#sink" = {
            node-type = "Audio/Sink";
            format = "{volume}% <span color='#a6e3a1'>{icon}</span>";
            format-muted = "{volume}% <span color='#f38ba8'>󰝟</span>";
            format-icons = [
              ""
              ""
              ""
            ];
            max-volume = 200;
            scroll-step = 0.2;
          };
          "wireplumber#source" = {
            node-type = "Audio/Source";
            format = "{volume}% <span color='#a6e3a1'></span>";
            format-muted = "{volume}% <span color='#f38ba8'></span>";
            max-volume = 200;
            scroll-step = 0.2;
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
      settings = {
        show-failed-attempts = true;
        image = config.home.homeDirectory + "/.local/state/wpaperd/wallpapers/eDP-1";
      };
    };
    rofi = {
      package = pkgs.rofi.override {
        plugins = with pkgs; [
          rofi-calc
        ];
      };
      extraConfig = {
        modi = "window,drun,run,ssh,calc";
        show-icons = true;
      };
      theme = "${pkgs.themes-rofi}/rounded-nord-dark.rasi";
    };
    kitty = {
      font = {
        package = pkgs.fira-code;
        name = "FiraCodeNFM-Reg";
      };
      settings = {
        background_opacity = "0.80";
        background_blur = "1";
        cursor_shape = "beam";
        allow_remote_control = true;
        dynamic_background_opacity = true;
        enable_audio_bell = false;
      };
      themeFile = "Catppuccin-Mocha";
    };
    imv = {
      settings = {
        options.fullscreen = true;
      };
    };
    mpv = {
      scripts = with pkgs.mpvScripts; [
        eisa01.smartskip
        thumbfast
        uosc
      ];
    };
    bash.profileExtra = ''[ "$(tty)" = "/dev/tty1" ] && exec sway '';
    zsh.loginExtra = ''[ "$(tty)" = "/dev/tty1" ] && exec sway '';
    nushell.loginFile.text = ''if (tty) == "/dev/tty1" { sway } '';
    firefox = {
      profiles.default = {
        id = 0;
        search = {
          default = "ddg";
          privateDefault = "ddg";
          force = true;
        };
        bookmarks = {
          force = true;
          settings = [
            {
              name = "home-options";
              url = "https://nix-community.github.io/home-manager/options.xhtml";
            }
            {
              name = "nixvim-docs";
              url = "https://nix-community.github.io/nixvim/";
            }
            {
              name = "noogle";
              url = "https://noogle.dev/";
            }
          ];
        };
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
  };
  services = {
    gpg-agent = {
      pinentry.package = pkgs.pinentry-qt;
    };
  };
  home = {
    packages = with pkgs; [
      openssl
      speedtest-cli
      uutils-coreutils-noprefix
      xdg-user-dirs
      xdg-utils
    ];
    pointerCursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
    };
  };
  wayland.windowManager.sway = {
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
      bars = [ ];
      gaps = {
        horizontal = 2;
        vertical = 2;
      };
      window = {
        titlebar = false;
        border = 0;
      };
      input = {
        "*" = {
          xkb_layout = "us,bg";
          xkb_options = "grp:win_space_toggle";
          xkb_variant = ",phonetic";
        };
      };
      keybindings = lib.mkOptionDefault {
        "XF86AudioMute" = "exec volume sink toggle";
        "Shift+XF86AudioMute" = "exec volume source toggle";
        "XF86AudioLowerVolume" = "exec volume sink down";
        "Shift+XF86AudioLowerVolume" = "exec volume source down";
        "XF86AudioRaiseVolume" = "exec volume sink up";
        "Shift+XF86AudioRaiseVolume" = "exec volume source up";
        "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
        "alt+shift+l" = "exec swaylock";
        "${modifier}+p" = "exec env rofi -show drun";
        "${modifier}+shift+s" = "exec screenshot screen";
        "${modifier}+shift+a" = "exec screenshot area";
        "${modifier}+shift+w" = "exec screenshot window";
        "end" = "exec rofi -show calc";
      };
    };
    extraConfig = ''
      blur enable
      shadows enable
      corner_radius 15
      default_dim_inactive 0.2
    '';
    swaynag = { inherit (config.wayland.windowManager.sway) enable; };
  };
  services = {
    wpaperd = {
      settings = {
        default = {
          path = "${config.xdg.userDirs.pictures}/bg";
          duration = "10m";
        };
      };
    };
    mako = {
      settings = {
        anchor = "bottom-right";
        background-color = "#1E1E2EDD";
        border-radius = 20;
      };
    };
  };
}
