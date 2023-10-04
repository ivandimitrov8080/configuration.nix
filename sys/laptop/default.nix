{ config, pkgs, ... }: {

  imports = [ ../../hardware-configuration.nix ];

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
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
    };
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
    };
  };

  time.timeZone = "Europe/Sofia";

  fonts.packages = with pkgs; [ nerdfonts noto-fonts noto-fonts-emoji noto-fonts-lgc-plus ];

  environment = {
    systemPackages = with pkgs; [
      binutils
      busybox
      cmatrix
      coreutils-full
      moreutils
      fd
      git
      glibc
      gcc13
      gnumake
      home-manager
      jq
      openssl
      libgccjit
      mlocate
      tealdeer
      unzip
      vim
      wget
      zip
      pinentry-qt
      ntfs3g
      wf-recorder
      # int
      python311
      nodejs_20
    ];
    variables = {
      EDITOR = "nvim";
    };
    shells = with pkgs; [ zsh ];
    etc = {
      "xdg/user-dirs.conf".text = ''
        enabled=True
      '';
    };
  };

  networking.extraHosts = builtins.readFile ./hosts;

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
    nix-ld.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.ivand = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "adm"
        "audio"
        "video"
        "kvm"
        "render"
        "flatpak"
        "bluetooth"
        "mlocate"
        "dialout"
      ];
    };
    extraGroups = { mlocate = { }; };
  };

  services = {
    xserver.videoDrivers = [ "nouveau" ];
    dbus.enable = true;
    flatpak.enable = true;
    ratbagd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
