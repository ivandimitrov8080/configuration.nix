{ config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

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
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
    };
  };

  time.timeZone = "Europe/Sofia";

  fonts.fonts = with pkgs; [ nerdfonts ];

  environment = {
    systemPackages = with pkgs; [
      binutils
      busybox
      cmatrix
      deno
      fd
      ffmpeg
      firefox-devedition-bin
      gimp
      git
      glibc
      glxinfo
      gnome.cheese
      gnumake
      grim
      home-manager
      jmtpfs
      jq
      libgccjit
      libmtp
      lolcat
      mako
      mlocate
      mupdf
      nodePackages_latest.pnpm
      nodejs_20
      pinentry-qt
      piper
      poetry
      python311
      python311Packages.pip
      rustup
      slurp
      tealdeer
      tectonic
      thunderbird
      tor-browser-bundle-bin
      ungoogled-chromium
      unzip
      vim
      vimPlugins.nvchad
      viu
      wayland
      wdisplays
      wget
      wl-clipboard
      xdg-user-dirs
      xdg-utils
      zbar
      zip
    ];
    variables = {
      EDITOR = "nvim";
      PNPM_HOME = "$HOME/.local/share/pnpm";
      QT_QPA_PLATFORM = "wayland";
    };
    shells = with pkgs; [ zsh ];
    etc = {
      "xdg/user-dirs.conf".text = ''
        enabled=True
      '';
    };
  };

  networking.extraHosts = builtins.readFile (pkgs.fetchFromGitHub
    {
      owner = "StevenBlack";
      repo = "hosts";
      rev = "5bf0802369cd74796bc5c4194c46ddc019541877";
      sha256 = "sha256-4CXI2vu/zBQeSzLKelaey/5WEjfroRs7LP9BvZ4CsTQ=";
    }
  + "/hosts");

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
      extraGroups = [ "wheel" "adm" "audio" "video" "kvm" "render" "flatpak" "bluetooth" "mlocate" ];
    };
    extraGroups = {
      mlocate = { };
    };
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
