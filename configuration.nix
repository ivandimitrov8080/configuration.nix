{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  system.stateVersion = "23.05";

  hardware = {
    pulseaudio.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
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
  };

  time.timeZone = "Europe/Sofia";

  environment = {
    systemPackages = with pkgs; [
      alejandra
      binutils
      cmatrix
      gimp
      git
      glibc
      gnome.cheese
      gnumake
      home-manager
      vimPlugins.nvchad
      jmtpfs
      libgccjit
      libmtp
      mlocate
      nodejs_20
      pinentry-qt
      rustup
      unzip
      vim
      wget
      xdg-user-dirs
      zbar
      zip
    ];
    variables = {
      EDITOR = "nvim";
    };
    shells = with pkgs; [zsh];
    etc = {
      "xdg/user-dirs.conf".text = ''
        enabled=True
      '';
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    sway.enable = true;
    zsh.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.ivand = {
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "mlocate"];
    };
    extraGroups = {
      mlocate = {};
    };
  };

  home-manager.users.ivand = {lib, ...}: {
    home = {
      stateVersion = "23.05";
      pointerCursor = let
        getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 48;
          package = pkgs.runCommand "moveUp" {} ''
            mkdir -p $out/share/icons
            ln -s ${pkgs.fetchzip {
              url = url;
              hash = hash;
            }} $out/share/icons/${name}
          '';
        };
      in
        getFrom
        "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata-Modern-Classic.tar.gz"
        "sha256-vn+91iKXWo++4bi3m9cmdRAXFMeAqLij+SXaSChedow="
        "Bibata_Modern_Classic";
      activation.createXdgFolders = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "$HOME/dl"
        mkdir -p "$HOME/doc"
        mkdir -p "$HOME/dt"
        mkdir -p "$HOME/pic"
        mkdir -p "$HOME/pub"
        mkdir -p "$HOME/snd"
        mkdir -p "$HOME/tp"
        mkdir -p "$HOME/vid"
      '';
    };
    programs = {
      home-manager = {
        enable = true;
      };
      git = {
        enable = true;
        userName = "Ivan Dimitrov";
        userEmail = "ivan@idimitrov.dev";
      };
      kitty = {
        enable = true;
        settings = {
          enable_tab_bar = false;
          background_opacity = "0.9";
        };
      };
      neovim = {
        enable = true;
        viAlias = true;
      };
      zsh = {
        enable = true;
        zplug = {
          enable = true;
          plugins = [
            {name = "jeffreytse/zsh-vi-mode";}
            {
              name = "romkatv/powerlevel10k";
              tags = [as:theme depth:1];
            }
            {name = "zsh-users/zsh-autosuggestions";}
            {
              name = "zsh-users/zsh-syntax-highlighting";
              tags = [defer:2];
            }
          ];
        };
        initExtra = ''
          source "$HOME/.p10k.zsh"
        '';
      };
    };
    xdg.configFile = {
      nvim = {
        source = pkgs.vimPlugins.nvchad;
        recursive = true;
      };
      "nvim/lua/custom" = {
        source = ./cfg/nvim/custom;
        recursive = true;
      };
      "user-dirs.dirs" = {
        source = pkgs.writeText "user-dirs.dirs" ''
          XDG_DESKTOP_DIR="$HOME/dt"
          XDG_DOCUMENTS_DIR="$HOME/doc"
          XDG_DOWNLOAD_DIR="$HOME/dl"
          XDG_MUSIC_DIR="$HOME/snd"
          XDG_PICTURES_DIR="$HOME/pic"
          XDG_PUBLICSHARE_DIR="$HOME/pub"
          XDG_TEMPLATES_DIR="$HOME/tp"
          XDG_VIDEOS_DIR="$HOME/vid"
        '';
      };
    };
    home.packages = with pkgs; [
      bemenu
      brave
      gopass
      gopass-jsonapi
      pavucontrol
    ];
  };
}
