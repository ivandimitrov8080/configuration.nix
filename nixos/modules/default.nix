{ moduleWithSystem, ... }: {
  flake.nixosModules = {
    wireguard = {
      networking.wg-quick.interfaces = {
        wg0 = {
          address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
          dns = [ "1.1.1.1" "fdc9:281f:04d7:9ee9::1" ];
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
    catppuccin = {
      catppuccin = {
        enable = true;
        flavor = "mocha";
      };
      boot.loader.grub.catppuccin.enable = true;
    };
    boot = {
      boot = {
        loader = {
          grub = {
            enable = true;
            useOSProber = true;
            efiSupport = true;
            device = "nodev";
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
          };
        };
        kernelModules = [ "v4l2loopback" ];
      };
    };
    security = moduleWithSystem (toplevel@{ ... }: nixos@{ pkgs, ... }: {
      security = {
        sudo = {
          enable = false;
          execWheelOnly = true;
          extraRules = [
            {
              groups = [ "wheel" ];
              commands = [{ command = "${pkgs.light}/bin/light"; options = [ "SETENV" "NOPASSWD" ]; }];
            }
          ];
        };
        doas = {
          enable = true;
          extraRules = [
            # Allow wheel to run all commands without password and keep user env.
            { groups = [ "wheel" ]; noPass = true; keepEnv = true; }
          ];
        };
        polkit.enable = true;
        rtkit.enable = true;
        pam = { services = { swaylock = { }; }; };
      };
    });
    xdg = {
      xdg = {
        portal = {
          enable = true;
          wlr.enable = true;
          config.common.default = "*";
        };
      };
    };
    networking = {
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
        stevenBlackHosts = {
          enable = true;
          blockFakenews = true;
          blockGambling = true;
        };
      };
    };
    users = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
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
    services = {
      services = {
        xserver.videoDrivers = [ "nouveau" ];
        dbus.enable = true;
        flatpak.enable = true;
        pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
        };
      };
    };
    programs = {
      programs = {
        zsh.enable = true;
        nix-ld.enable = true;
        adb.enable = true;
        dconf.enable = true;
      };
    };
    env = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      environment = {
        systemPackages = with pkgs; [
          cmatrix
          coreutils-full
          cryptsetup
          dig
          fd
          file
          git
          glibc
          gnumake
          jq
          mlocate
          moreutils
          ntfs3g
          openssl
          srm
          unzip
          vim
          zip
        ];
        shells = with pkgs; [ zsh nushell ];
      };
    });
    rest = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      nix = {
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
      };
      system.stateVersion = "24.05";
      hardware = {
        graphics = {
          enable = true;
        };
      };
      i18n.supportedLocales = [ "all" ];
      time.timeZone = "Europe/Prague";
      fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) noto-fonts noto-fonts-emoji noto-fonts-lgc-plus ];
    });
  };
}
