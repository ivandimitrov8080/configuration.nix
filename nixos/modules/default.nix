top@{ moduleWithSystem, ... }: {
  flake.nixosModules = {
    grub = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      boot = {
        loader = {
          grub =
            let
              theme = pkgs.sleek-grub-theme.override { withBanner = "Hello Ivan"; withStyle = "bigSur"; };
            in
            { enable = true; useOSProber = true; efiSupport = true; device = "nodev"; theme = theme; splashImage = "${theme}/background.png"; };
          efi = { canTouchEfiVariables = true; };
        };
      };
    });
    base = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      system.stateVersion = top.config.flake.stateVersion;
      nix = { extraOptions = ''experimental-features = nix-command flakes''; };
      i18n.supportedLocales = [ "all" ];
      time.timeZone = "Europe/Prague";
      fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) noto-fonts noto-fonts-emoji noto-fonts-lgc-plus ];
      environment = {
        systemPackages = with pkgs; [ cmatrix uutils-coreutils cryptsetup fd file git glibc gnumake mlocate moreutils openssh openssl procs ripgrep srm unzip vim zip ];
        shells = with pkgs; [ zsh nushell ];
      };
      programs = { zsh.enable = true; nix-ld.enable = true; dconf.enable = true; };
      services = { dbus.enable = true; };
      networking = { stevenBlackHosts = { enable = true; blockFakenews = true; blockGambling = true; }; };
    });
    sound = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      services = { pipewire = { enable = true; alsa.enable = true; pulse.enable = true; }; };
      environment.systemPackages = with pkgs; [ pwvucontrol ];
    });
    music = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      environment.systemPackages = with pkgs; [ guitarix ];
      services.pipewire = {
        jack.enable = true;
        extraConfig = { jack."69-low-latency" = { "jack.properties" = { "node.latency" = "64/48000"; }; }; };
      };
      musnix = {
        enable = true;
        rtcqs.enable = true;
        soundcardPciId = "00:1f.3";
        kernel = { realtime = true; packages = pkgs.linuxPackages_6_8_rt; };
        rtirq = { resetAll = 1; prioLow = 0; enable = true; nameList = "rtc0 snd"; };
      };
    });
    wayland = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: { hardware.graphics.enable = true; security.pam.services.swaylock = { }; });
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
          address = [ "10.0.0.4/32" ];
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
          };
        };
      };
    };
    ivand = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      users = {
        defaultUserShell = pkgs.zsh;
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
              "render"
              "video"
              "wheel"
            ];
          };
        };
        extraGroups = { mlocate = { }; };
      };
    });
    flatpak = {
      xdg = { portal = { enable = true; wlr.enable = true; config.common.default = "*"; }; };
      services.flatpak.enable = true;
    };
    ai = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: {
      services = { ollama.enable = true; };
    });
    nonya = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      environment.systemPackages = with pkgs; [ tor-browser electrum monero-cli ];
      services.monero = { enable = true; };
    });
  };
}
