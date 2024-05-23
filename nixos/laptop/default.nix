{ config, pkgs, ... }: {

  system.stateVersion = "23.11";

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        catppuccin.enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
  };

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

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      config.common.default = "*";
    };
  };

  i18n.supportedLocales = [ "all" ];

  time.timeZone = "Europe/Sofia";

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) noto-fonts noto-fonts-emoji noto-fonts-lgc-plus ];

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
      };
    };
    stevenBlackHosts = {
      enable = true;
      blockFakenews = true;
      blockGambling = true;
    };
  };

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
    adb.enable = true;
    dconf.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      ivand = {
        shell = pkgs.nushell;
        isNormalUser = true;
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
}
