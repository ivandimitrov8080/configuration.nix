{ config, pkgs, ... }: {

  system.stateVersion = "23.11";

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
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

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
  };

  security = {
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

  time.timeZone = "Europe/Sofia";

  fonts.packages = with pkgs; [ nerdfonts noto-fonts noto-fonts-emoji noto-fonts-lgc-plus ];

  environment = {
    systemPackages = with pkgs; [
      acpi
      binutils
      bun
      cmatrix
      coreutils-full
      cryptsetup
      dig
      fd
      file
      gcc13
      git
      glibc
      gnumake
      home-manager
      jq
      libgccjit
      mlocate
      moreutils
      nix-prefetch-github
      nodejs_20
      ntfs3g
      openssl
      python311
      srm
      unzip
      vim
      wf-recorder
      wget
      zip
    ];
    variables = {
      EDITOR = "nvim";
    };
    shells = with pkgs; [ zsh nushell ];
    etc = {
      "xdg/user-dirs.conf".text = ''
        enabled=True
      '';
    };
  };

  networking = {
    wireless = {
      enable = true;
      networks = {
        "Smart-Hostel-2.4" = {
          psk = "smarttrans.bg";
        };
      };
    };
    stevenBlackHosts = {
      enable = true;
      blockFakenews = true;
      blockGambling = true;
      # blockSocial = true;
    };
  };

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
    wshowkeys.enable = true;
    adb.enable = true;
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
    ratbagd.enable = true;
    postgresql.enable = true;
    upower.enable = true;
    i2pd = {
      enable = true;
      proto.httpProxy.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  virtualisation = {
    waydroid.enable = true;
  };
}
