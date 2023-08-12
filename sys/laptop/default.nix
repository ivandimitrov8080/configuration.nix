{ config, pkgs, ... }: {

  imports = [ ../../hardware-configuration.nix ];

  system.stateVersion = "23.05";

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
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

  fonts.packages = with pkgs; [ nerdfonts noto-fonts ];

  environment = {
    systemPackages = with pkgs; [
      binutils
      busybox
      cmatrix
      coreutils-full
      fd
      git
      glibc
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
    ];
    variables = {
      EDITOR = "nvim";
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };
    shells = with pkgs; [ zsh ];
    etc = {
      "xdg/user-dirs.conf".text = ''
        enabled=True
      '';
    };
  };

  networking.extraHosts = builtins.readFile (pkgs.fetchFromGitHub {
    owner = "StevenBlack";
    repo = "hosts";
    rev = "5bf0802369cd74796bc5c4194c46ddc019541877";
    sha256 = "sha256-4CXI2vu/zBQeSzLKelaey/5WEjfroRs7LP9BvZ4CsTQ=";
  } + "/hosts");

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
