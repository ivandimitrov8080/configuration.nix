{ moduleWithSystem, ... }: {
  flake.nixosModules = {
    grub = {
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
          };
        };
      };
    };
    base = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      system.stateVersion = "24.05";
      nix = {
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
      };
      hardware.graphics.enable = true;
      i18n.supportedLocales = [ "all" ];
      time.timeZone = "Europe/Prague";
      fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) noto-fonts noto-fonts-emoji noto-fonts-lgc-plus ];
      environment = {
        systemPackages = with pkgs; [
          cmatrix
          coreutils-full
          cryptsetup
          fd
          file
          git
          glibc
          gnumake
          mlocate
          moreutils
          openssl
          srm
          unzip
          vim
          zip
        ];
        shells = with pkgs; [ zsh nushell ];
      };
      programs = {
        zsh.enable = true;
        nix-ld.enable = true;
        dconf.enable = true;
      };
      services = {
        dbus.enable = true;
      };
      networking = {
        stevenBlackHosts = {
          enable = true;
          blockFakenews = true;
          blockGambling = true;
        };
      };
    });
    sound = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: {
      services = {
        pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
        };
      };
    });
    security = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: {
      security = {
        sudo = {
          enable = false;
          execWheelOnly = true;
          extraRules = [
            {
              groups = [ "wheel" ];
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
    testUser = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      users = {
        defaultUserShell = pkgs.zsh;
        users = {
          test = {
            isNormalUser = true;
            createHome = true;
            initialPassword = "test";
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
    style = {
      catppuccin = {
        enable = true;
        flavor = "mocha";
      };
      boot.loader.grub.catppuccin.enable = true;
    };
    flatpak = {
      xdg = {
        portal = {
          enable = true;
          wlr.enable = true;
          config.common.default = "*";
        };
      };
      services.flatpak.enable = true;
    };
    ai = moduleWithSystem (toplevel@{ ... }: perSystem@{ ... }: {
      services = {
        ollama.enable = true;
      };
    });
    vm = moduleWithSystem (toplevel@{ ... }: perSystem@{ pkgs, ... }: {
      nixpkgs.hostPlatform = "x86_64-linux";
      virtualisation.vmVariant = {
        # following configuration is added only when building VM with build-vm
        virtualisation = {
          memorySize = 8192;
          cores = 4;
          resolution = {
            x = 1920;
            y = 1080;
          };
          diskImage = "$HOME/doc/vm.qcow2";
          qemu = {
            options = [ "-vga qxl" "-spice port=5900,addr=127.0.0.1,disable-ticketing=on" ];
          };
        };
        services = {
          displayManager.sddm.enable = true;
          xserver = {
            enable = true;
            desktopManager.xfce.enable = true;
            videoDrivers = [ "qxl" ];
          };
          spice-autorandr.enable = true;
          spice-vdagentd.enable = true;
          spice-webdavd.enable = true;
        };
        environment = {
          systemPackages = with pkgs; [
            xorg.xf86videoqxl
            tor-browser
            gnupg
          ];
        };
      };
    });
  };
}
