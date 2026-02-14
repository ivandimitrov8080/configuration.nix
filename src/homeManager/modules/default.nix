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
      package = pkgs.firefox.override {
        nativeMessagingHosts = [
          pkgs.tridactyl-native
        ];
      };
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
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome =
          # css
          ''
            :root {
            	--tab-active-bg-color: #057;
            	--tab-inactive-bg-color: #333;
            	--tab-active-fg-fallback-color: #eee;		/* color of text in an active tab without a container */
            	--tab-inactive-fg-fallback-color: #888;		/* color of text in an inactive tab without a container */
            	--urlbar-focused-bg-color: #41404c;
            	--urlbar-not-focused-bg-color: #1c1b22;
            	--toolbar-bgcolor: #2b2a33 !important;
            	--tab-font: 'DejaVu Sans Mono';
            	--urlbar-font: 'DejaVu Sans Mono';

            	/* try increasing if you encounter problems */
            	--urlbar-height-setting: 22px;
            	--tab-min-height: 16px !important;

            	/* I don't recommend you touch this unless you know what you're doing */
            	--arrowpanel-menuitem-padding: 2px !important;
            	--arrowpanel-border-radius: 0px !important;
            	--arrowpanel-menuitem-border-radius: 0px !important;
            	--toolbarbutton-border-radius: 0px !important;
            	--toolbarbutton-inner-padding: 0px 2px !important;
            	--toolbar-field-focus-background-color: var(--urlbar-focused-bg-color) !important;
            	--toolbar-field-background-color: var(--urlbar-not-focused-bg-color) !important;
            	--toolbar-field-focus-border-color: transparent !important;
            }

            /* --- GENERAL DEBLOAT ---------------------------------- */

            /* Bottom left page loading status or url preview */
            #statuspanel { display: none !important; }

            /* remove radius from right-click popup */
            menupopup, panel { --panel-border-radius: 0px !important; }
            menu, menuitem, menucaption { border-radius: 0px !important; }

            /* no stupid large buttons in right-click menu */
            menupopup > #context-navigation { display: none !important; }
            menupopup > #context-sep-navigation { display: none !important; }

            /* --- DEBLOAT NAVBAR ----------------------------------- */

            #back-button { display: none; }
            #forward-button { display: none; }
            #reload-button { display: none; }
            #stop-button { display: none; }
            #home-button { display: none; }
            #library-button { display: none; }
            /* #fxa-toolbar-menu-button { display: none; } */
            /* empty space before and after the url bar */
            #customizableui-special-spring1, #customizableui-special-spring2 { display: none; }
            .private-browsing-indicator-with-label { display: none; }

            /* --- STYLE NAVBAR ------------------------------------ */

            /* remove padding between toolbar buttons */
            toolbar .toolbarbutton-1 { padding: 0 0 !important; }

            /* add it back to the downloads button, otherwise it's too close to the urlbar */
            #downloads-button {
            	margin-left: 2px !important;
            }

            /* add padding to the right of the last button so that it doesn't touch the edge of the window */
            #PanelUI-menu-button {
            	padding: 0px 4px 0px 0px !important;
            }

            #urlbar-container {
            	--urlbar-container-height: var(--urlbar-height-setting) !important;
            	margin-left: 0 !important;
            	margin-right: 0 !important;
            	padding-top: 0 !important;
            	padding-bottom: 0 !important;
            	font-family: var(--urlbar-font, 'monospace');
            	font-size: 11px;
            }

            #urlbar {
            	--urlbar-height: var(--urlbar-height-setting) !important;
            	--urlbar-toolbar-height: var(--urlbar-height-setting) !important;
            	min-height: var(--urlbar-height-setting) !important;
            	border-color: var(--lwt-toolbar-field-border-color, hsla(240,5%,5%,.25)) !important;
            }

            #urlbar-input {
            	margin-left: 0.4em !important;
            	margin-right: 0.4em !important;
            }
            #urlbar > .urlbar-input-container {
            	padding: 0 !important;
            	border: 0 !important;
            }

            #navigator-toolbox {
            	border: none !important;
            }

            /* keep pop-up menus from overlapping with navbar */
            #widget-overflow { margin: 3px !important; }
            #customizationui-widget-panel { margin: 3px !important; }
            #unified-extensions-panel { margin-top: 3px !important; }
            #appMenu-popup { margin-top: 3px !important; }

            /* --- UNIFIED EXTENSIONS BUTTON ------------------------ */

            /* make extension icons smaller */
            #unified-extensions-view {
            	--uei-icon-size: 16px;
            }

            /* hide bloat */
            .unified-extensions-item-message-deck,
            #unified-extensions-view > .panel-header,
            #unified-extensions-view > toolbarseparator,
            #unified-extensions-manage-extensions {
            	display: none !important;
            }

            /* add 3px padding on the top and the bottom of the box */
            .panel-subview-body {
            	padding: 3px 0px !important;
            }

            #unified-extensions-view .toolbarbutton-icon {
            	padding: 0 !important;
            }

            .unified-extensions-item-contents {
            	line-height: 1 !important;
            	white-space: nowrap !important;
            }

            #unified-extensions-panel .unified-extensions-item {
            	margin-block: 0 !important;
            }

            .toolbar-menupopup :is(menu, menuitem), .subview-subheader, panelview
            .toolbarbutton-1, .subviewbutton, .widget-overflow-list .toolbarbutton-1 {
            	padding: 4px !important;
            }

            /* --- DEBLOAT URLBAR ----------------------------------- */

            #pageActionButton { display: none; }
            #pocket-button { display: none; }
            #urlbar-zoom-button { display: none; }
            #tracking-protection-icon-container { display: none !important; }
            /* #reader-mode-button{ display: none !important; } */
            /* #star-button { display: none; } */
            /* #star-button-box:hover { background: inherit !important; } */
            #urlbar-searchmode-switcher { display: none; }
            #searchmode-switcher-chicklet { display: none !important; }

            /* hide container indicators; we indicate container by changing tab title text color */
            #identity-icon-box {
            	margin-inline-end: 0 !important;
            	padding: 0 4px !important;
            }
            .tabbrowser-tab[usercontextid] > .tab-stack > .tab-background > .tab-context-line {
            	display: none !important;
            }

            /* Go to arrow button at the end of the urlbar when searching */
            #urlbar-go-button { display: none; }

            /* remove container indicator from urlbar */
            #userContext-label, #userContext-indicator { display: none !important;}

            /* --- STYLE TAB TOOLBAR -------------------------------- */

            #titlebar {
            	--proton-tab-block-margin: 0px !important;
            	--tab-block-margin: 0px !important;
            }

            #TabsToolbar, .tabbrowser-tab {
            	max-height: var(--tab-min-height) !important;
            	font-size: 11px !important;
            }

            /* Change color of normal tabs */
            tab:not([selected="true"]) {
            	background-color: var(--tab-inactive-bg-color) !important;
            	color: var(--identity-icon-color, var(--tab-inactive-fg-fallback-color)) !important;
            }

            tab {
            	font-family: var(--tab-font, monospace);
            	font-weight: bold;
            	border: none !important;
            	padding-top: 0 !important;
            }

            .tab-content {
            	padding: 0 0 0 var(--tab-inline-padding);
            }

            .tab-background {
            	margin-block: 0 !important;
            	min-height: var(--tab-min-height);
            	outline-offset: 0 !important;
            }

            /* safari style tab width */
            .tabbrowser-tab[fadein] {
            	max-width: 100vw !important;
            	border: none
            }

            /* Hide close button on tabs */
            #tabbrowser-tabs .tabbrowser-tab .tab-close-button { display: none !important; }

            /* disable favicons in tab */
            /* .tab-icon-stack:not([pinned]) { display: none !important; } */

            .tabbrowser-tab {
            	/* remove border between tabs */
            	padding-inline: 0px !important;
            	/* reduce fade effect of tab text */
            	--tab-label-mask-size: 1em !important;
            	/* fix pinned tab behaviour on overflow */
            	overflow-clip-margin: 0px !important;
            }

            /* Tab: selected colors */
            #tabbrowser-tabs .tabbrowser-tab[selected] .tab-content {
            	background: var(--tab-active-bg-color) !important;
            	color: var(--identity-icon-color, var(--tab-active-fg-fallback-color)) !important;
            }

            /* Tab: hovered colors */
            #tabbrowser-tabs .tabbrowser-tab:hover:not([selected]) .tab-content {
            	background: var(--tab-active-bg-color) !important;
            }

            /* hide window controls */
            .titlebar-buttonbox-container { display: none; }

            /* remove titlebar spacers */
            .titlebar-spacer { display: none !important; }

            /* disable tab shadow */
            #tabbrowser-tabs:not([noshadowfortests]) .tab-background:is([selected], [multiselected]) {
                box-shadow: none !important;
            }

            /* remove dark space between pinned tab and first non-pinned tab */
            #pinned-tabs-container {
            	margin-inline-end: 0 !important;
            }

            /* remove dropdown menu button which displays all tabs on overflow */
            #alltabs-button { display: none !important }

            /* fix displaying of pinned tabs on overflow */
            #tabbrowser-tabs:not([secondarytext-unsupported]) .tab-label-container {
            	height: var(--tab-min-height) !important;
            }

            #tabbrowser-tabs {
            	min-height: var(--tab-min-height) !important;
            }

            /* remove overflow scroll buttons */
            #scrollbutton-up, #scrollbutton-down { display: none !important; }

            /* remove new tab button */
            #tabs-newtab-button {
            	display: none !important;
            }

            /* hide private browsing indicator */
            #private-browsing-indicator-with-label {
            	display: none;
            }

            /* --- AUTOHIDE NAVBAR ---------------------------------- */

            :root {
            	--uc-navbar-transform: calc(0px - var(--urlbar-height-setting));
            }

            #navigator-toolbox > div {
            	display: contents;
            }

            :root[sessionrestored] :where(
            	#nav-bar,
            	#PersonalToolbar,
            	#tab-notification-deck,
            	.global-notificationbox
            ) {
            	transform: translateY(var(--uc-navbar-transform));
            }

            :root:is([customizing], [chromehidden*="toolbar"]) :where(
            	#nav-bar,
            	#PersonalToolbar,
            	#tab-notification-deck,
            	.global-notificationbox
            ) {
            	transform: none !important;
            	opacity: 1 !important;
            }

            #nav-bar:not([customizing]) {
            	opacity: 0;
            	position: relative;
            	z-index: 2;
            }

            #titlebar {
            	position: relative;
            	z-index: 3;
            }

            #navigator-toolbox,
            #sidebar-box,
            #sidebar-main,
            #sidebar-splitter,
            #tabbrowser-tabbox {
            	z-index: auto !important;
            }

            /* Show when toolbox is focused, like when urlbar has received focus */
            #navigator-toolbox:focus-within > .browser-toolbar {
            	transform: translateY(0);
            	opacity: 1;
            }

            /* Show when toolbox is hovered */
            #titlebar:hover ~ .browser-toolbar,
            .browser-titlebar:hover ~ :is(#nav-bar, #PersonalToolbar),
            #nav-bar:hover,
            #nav-bar:hover + #PersonalToolbar {
            	transform: translateY(0);
            	opacity: 1;
            }

            :root[sessionrestored] #urlbar[popover] {
            	opacity: 0;
            	pointer-events: none;
            	transform: translateY(var(--uc-navbar-transform));
            }

            #mainPopupSet:has(> [panelopen]:not(
            	#ask-chat-shortcuts,
            	#selection-shortcut-action-panel,
            	#chat-shortcuts-options-panel,
            	#tab-preview-panel
            )) ~ toolbox #urlbar[popover],
            .browser-titlebar:is(:hover, :focus-within) ~ #nav-bar #urlbar[popover],
            #nav-bar:is(:hover, :focus-within) #urlbar[popover],
            #urlbar-container > #urlbar[popover]:is([focused], [open]) {
            	opacity: 1;
            	pointer-events: auto;
            	transform: translateY(0);
            }

            /* This ruleset is separate, because not having :has support breaks other selectors as well */
            #mainPopupSet:has(> [panelopen]:not(
            	#ask-chat-shortcuts,
            	#selection-shortcut-action-panel,
            	#chat-shortcuts-options-panel,
            	#tab-preview-panel
            )) ~ #navigator-toolbox > .browser-toolbar {
            	transform: translateY(0);
            	opacity: 1;
            }

            /* Move up the content view */
            :root[sessionrestored]:not([chromehidden~="toolbar"]) > body > #browser {
            	margin-top: var(--uc-navbar-transform);
            }
          '';
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
