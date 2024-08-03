top@{ inputs, moduleWithSystem, ... }: {
  flake.nixosModules = {
    grub = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      boot = {
        loader = {
          grub =
            let
              theme = pkgs.sleek-grub-theme.override { withBanner = "Hello Ivan"; withStyle = "bigSur"; };
            in
            { enable = pkgs.lib.mkDefault true; useOSProber = true; efiSupport = true; device = "nodev"; theme = theme; splashImage = "${theme}/background.png"; };
          efi = { canTouchEfiVariables = true; };
        };
      };
    });
    base = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      imports = [ inputs.hosts.nixosModule ];
      system.stateVersion = top.config.flake.stateVersion;
      nix = { extraOptions = ''experimental-features = nix-command flakes''; };
      i18n.supportedLocales = [ "all" ];
      time.timeZone = "Europe/Prague";
      environment = {
        systemPackages = with pkgs; [ cmatrix uutils-coreutils-noprefix cryptsetup fd file git glibc gnumake mlocate openssh openssl procs ripgrep srm unzip vim zip just nixos-install-tools ];
        sessionVariables = { MAKEFLAGS = "-j 4"; };
        shells = with pkgs; [ bash zsh nushell ];
        enableAllTerminfo = true;
      };
      users.defaultUserShell = pkgs.zsh;
      programs = { zsh.enable = true; nix-ld.enable = true; };
      services = {
        dbus.enable = true;
        logind = { lidSwitch = "lock"; lidSwitchDocked = "lock"; killUserProcesses = true; powerKeyLongPress = "reboot"; };
      };
      networking = { stevenBlackHosts = { enable = true; blockFakenews = true; blockGambling = true; blockSocial = true; }; };
    });
    shell = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      programs = {
        starship.enable = true;
        zsh = {
          enableBashCompletion = true;
          syntaxHighlighting.enable = true;
          autosuggestions = {
            enable = true;
            strategy = [ "completion" ];
          };
          shellAliases = {
            cal = "cal $(date +%Y)";
            GG = "git add . && git commit -m 'GG' && git push --set-upstream origin HEAD";
            gad = "git add . && git diff --cached";
            gac = "ga && gc";
            ga = "git add .";
            gc = "git commit";
            dev = "nix develop --command $SHELL";
            eza = "${pkgs.eza}/bin/eza '--long' '--header' '--icons' '--smart-group' '--mounts' '--octal-permissions' '--git'";
            ls = "eza";
            la = "eza --all";
            lt = "eza --git-ignore --all --tree --level=10";
            sc = "systemctl";
            neofetch = "${pkgs.fastfetch}/bin/fastfetch -c all.jsonc";
          };
        };
      };
    });
    sound = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      services = { pipewire = { enable = true; alsa.enable = true; pulse.enable = true; }; };
      environment.systemPackages = with pkgs; [ pwvucontrol ];
    });
    music = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      imports = [ inputs.musnix.nixosModules.musnix ];
      environment.systemPackages = with pkgs; [ guitarix ];
      services.pipewire = {
        jack.enable = true;
        extraConfig = { jack."69-low-latency" = { "jack.properties" = { "node.latency" = "64/48000"; }; }; };
      };
      musnix = {
        enable = true;
        rtcqs.enable = true;
        soundcardPciId = "00:1f.3";
        kernel = { realtime = true; packages = pkgs.linuxPackages-rt; };
      };
    });
    wayland = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: {
      hardware.graphics.enable = true;
      security.pam.services.swaylock = { };
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        wlr = { enable = true; settings = { screencast = { output_name = "HDMI-A-1"; max_fps = 60; }; }; };
        config.common.default = "*";
      };
    });
    security = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: {
      security = {
        sudo = { enable = false; execWheelOnly = true; extraRules = [{ groups = [ "wheel" ]; }]; };
        doas = { enable = true; extraRules = [{ groups = [ "wheel" ]; noPass = true; keepEnv = true; }]; };
        polkit.enable = true;
        rtkit.enable = true;
      };
    });
    wireguard = {
      networking.wg-quick.interfaces = {
        wg0 = {
          address = [ "10.0.0.2/32" ];
          privateKeyFile = "/etc/wireguard/privatekey";
          peers = [
            {
              publicKey = "5FiTLnzbgcbgQLlyVyYeESEd+2DtwM1JHCGz/32UcEU=";
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              endpoint = "37.205.13.29:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
    wireless = {
      networking = {
        wireless = {
          enable = true;
          networks = {
            "Smart-Hostel-2.4" = {
              psk = "smarttrans.bg";
            };
            "Yohohostel2.4G" = {
              psk = "kaskamaska";
            };
            "Nomado_Guest" = {
              psk = "welcomehome";
            };
            "HostelMusala Uni" = {
              psk = "mhostelm";
            };
            "BOUTIQUE APARTMENTS" = {
              psk = "boutique26";
            };
            "Safestay" = {
              psk = "AlldayrooftopBAR";
            };
            "HOSTEL JASMIN 2" = {
              psk = "Jasmin2024";
            };
            "HOME" = {
              psk = "iloveprague";
            };
            "Vodafone-B925" = {
              psk = "7aGh3FE6pN4p4cu6";
            };
            "O2WIFIZ_EXT" = {
              psk = "iloveprague";
            };
            "KOTEKLAN_GUEST" = {
              psk = "koteklankotek";
            };
            "3G" = {
              hidden = true;
            };
          };
        };
      };
    };
    ivand = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }:
      let homeMods = top.config.flake.homeManagerModules; in {
        imports = [ inputs.home-manager.nixosModules.default ];
        home-manager = {
          backupFileExtension = "bak";
          useUserPackages = true;
          useGlobalPkgs = true;
          users.ivand = { ... }: {
            imports = with homeMods; [
              base
              ivand
              shell
              util
              swayland
              web
            ];
          };
        };
        fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) noto-fonts noto-fonts-emoji noto-fonts-lgc-plus ];
        users = {
          users = {
            ivand = {
              isNormalUser = true;
              createHome = true;
              extraGroups = [
                "adbusers"
                "adm"
                "audio"
                "bluetooth"
                "dialout"
                "flatpak"
                "kvm"
                "mlocate"
                "realtime"
                "render"
                "video"
                "wheel"
              ];
            };
          };
          extraGroups = { mlocate = { }; };
        };
        programs.dconf.enable = true;
      });
    flatpak = {
      xdg = { portal = { enable = true; wlr.enable = true; config.common.default = "*"; }; };
      services.flatpak.enable = true;
    };
    ai = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: {
      services = { ollama.enable = true; };
    });
    anon = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      environment.systemPackages = with pkgs; [ tor-browser ];
    });
    cryptocurrency = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      environment.systemPackages = with pkgs; [ monero-cli ];
      services = { monero.enable = true; };
    });
    vps = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: {
      imports = [
        inputs.vpsadminos.nixosConfigurations.container
        inputs.simple-nixos-mailserver.nixosModule
        ../../hosts/vps/mailserver
      ];
    });
  };
}
