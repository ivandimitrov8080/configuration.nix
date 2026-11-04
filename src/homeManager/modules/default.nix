{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (import ../../lib { inherit lib; }) mkDefaultAttrs values;
  shellAliases =
    values.shellAliases // (if config.programs.zoxide.enable then values.zoxideAliases else { });
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
    };
  };
  home = {
    shell.enableShellIntegration = true;
    pointerCursor = {
      enable = true;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      sway.enable = config.wayland.windowManager.sway.enable;
    };
    sessionVariables = {
      PAGER = "bat";
      WLR_RENDERER_ALLOW_SOFTWARE = 1;
      QT_QPA_PLATFORM = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };
    file = {
      ".tridactylrc".text = ''
        set smoothscroll true
        bind j scrollline 4
        bind k scrollline -4
        bind b fillcmdline bmarks
        bind <Tab> tabnext
        bind <S-Tab> tabprev
        bind x tabclose
        unbind d
      '';
      ".vit/config.ini".text = ''
        [taskwarrior]
        taskrc = ~/.config/task/taskrc
        [vit]
        default_keybindings = vi
        confirmation = False
        mouse = True
        abort_backspace = True
        focus_on_add = True
        wait = False
        row_stripping = False
        [keybinding]
        q = {ACTION_QUIT}
      '';
    };
  };
  accounts = {
    calendar.basePath = ".local/share/calendars";
    contact.basePath = ".local/share/contacts";
    email.maildirBasePath = ".local/share/mail";
  };
  programs = {
    taskwarrior = {
      package = pkgs.taskwarrior3;
      config = {
        confirmation = false;
        default = {
          project = "misc";
          priority = "M";
          due = "+7days";
        };
      };
    };
    w3m.enable = config.programs.aerc.enable;
    khard.enable = config.programs.aerc.enable;
    offlineimap.enable = config.programs.aerc.enable;
    ssh = {
      enableDefaultConfig = false;
      settings = {
        "*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
        };
      };
    };
    password-store = {
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
      config = {
        plain = true;
      };
    };
    bash = {
      historyControl = [ "erasedups" ];
      historyIgnore = [
        "ls"
        "cd"
        "exit"
      ];
    };
    zsh = {
      inherit shellAliases;
      defaultKeymap = "viins";
      enableVteIntegration = true;
      dotDir = "${config.xdg.configHome}/zsh";
      syntaxHighlighting = {
        enable = true;
        highlighters = values.zsh.highlighters;
      };
      autosuggestion = {
        enable = true;
        highlight = values.zsh.highlightStyle;
        strategy = values.zsh.autosuggestionStrategy;
      };
      history.expireDuplicatesFirst = true;
      historySubstringSearch.enable = true;
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    nushell = {
      plugins = with pkgs.nushellPlugins; [
        formats
        gstat
        polars
        query
      ];
      settings = {
        show_banner = false;
        completions.external = {
          enable = true;
          max_results = 250;
        };
        history.file_format = "sqlite";
        edit_mode = "vi";
        use_kitty_protocol = config.programs.kitty.enable;
      };
      shellAliases = (removeAttrs shellAliases [ "ls" ]) // {
        la = "ls -al";
      };
      extraConfig = lib.mkAfter ''
        def l [...args] { ls -al | select name type readonly mode num_links inode user group size created accessed modified | sort-by name | sort-by type }
      '';
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
        set-option -g focus-events on
        set -s copy-command 'wl-copy'
        set -g default-command "''${SHELL}"
      '';
    };
    eza = {
      extraOptions = values.ezaFlags;
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
            exec = "${pkgs.wttrbar}/bin/wttrbar";
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
        targets = [ "sway-session.target" ];
      };
      style = ''
        @import "${config.xdg.configHome}/waybar/catppuccin.css";
        ${builtins.readFile ./waybar/main.css}
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
      settings = {
        modi = "window,drun,run,ssh,calc";
        show-icons = true;
        show-actions = true;
      };
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
    firefox = {
      package = pkgs.firefox-devedition.override {
        nativeMessagingHosts = [
          pkgs.tridactyl-native
        ];
      };
      profiles.dev-edition-default = {
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
              name = "nixos-options";
              url = "https://nixos.org/manual/nixos/unstable/options.html";
            }
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
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
          "*".installation_mode = "blocked";
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
          # Vim-like keybinds
          "tridactyl.vim@cmcaine.co.uk" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
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
  wayland.windowManager.sway = {
    package = pkgs.swayfx;
    checkConfig = false;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      menu = "rofi -show drun";
      terminal = "kitty";
      modifier = "Mod4";
      bars = [ ];
      gaps = {
        horizontal = 2;
        vertical = 2;
      };
      window = {
        titlebar = false;
        border = 0;
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
