{ pkgs
, lib
, ...
}: {
  home = {
    username = "ivand";
    homeDirectory = "/home/ivand";
    stateVersion = "23.05";
    sessionPath = [ "$HOME/.local/bin/" "$HOME/.local/share/pnpm" ];
    pointerCursor = {
      name = "Bibata-Modern-Amber";
      package = pkgs.bibata-cursors;
    };
    packages = with pkgs; [
      bemenu
      brave
      direnv
      gopass
      gopass-jsonapi
      pavucontrol
    ];
  };
  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Ivan Dimitrov";
      userEmail = "ivan@idimitrov.dev";
      extraConfig = {
        color.ui = "auto";
        pull.rebase = true;
      };
    };
    kitty = {
      enable = true;
      settings = {
        enable_tab_bar = false;
        background_opacity = "0.96";
      };
    };
    tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
        tilish
        catppuccin
      ];
      extraConfig = ''
                                set -g default-command "''${SHELL}"
                        	set -g default-terminal "tmux-256color"
                		set -g base-index 1
        			set -s escape-time 0
      '';
    };
    swaylock = {
      enable = true;
      settings = {
        color = "000000";
        line-color = "ffffff";
        show-failed-attempts = true;
      };
    };
    neovim = {
      enable = true;
      viAlias = true;
      extraPackages = with pkgs; [
        alejandra
        black
        go
        gopls
        libclang
        lua
        lua-language-server
        nodePackages_latest.prettier
        nodePackages_latest.typescript
        nodePackages_latest.typescript-language-server
        nodePackages_latest."@tailwindcss/language-server"
        nodePackages_latest."@prisma/language-server"
        python311Packages.python-lsp-black
        python311Packages.python-lsp-server
        ripgrep
        rnix-lsp
        stylua
      ];
      plugins = with pkgs.vimPlugins; [
        nvim-surround
        nvim-ts-autotag
        vim-prisma
        autoclose-nvim
        barbar-nvim
        cmp-nvim-lsp
        comment-nvim
        gitsigns-nvim
        luasnip
        nightfox-nvim
        nvim-cmp
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        nvim-web-devicons
        plenary-nvim
        telescope-nvim
        telescope-nvim
        toggleterm-nvim
        vim-vinegar
      ];
      extraLuaConfig = lib.fileContents ./cfg/nvim/init.lua;
    };
    doom-emacs = {
      enable = true;
      doomPrivateDir = ./cfg/doom.d;
      extraPackages = with pkgs; [
        nixfmt
      ];
    };
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      enableAutosuggestions = true;
      loginExtra = ''
        [ "$(tty)" = "/dev/tty1" ] && exec sway
      '';
      shellAliases = {
        gad = "git add . && git diff --cached";
        gac = "ga && gc";
        ga = "git add .";
        gc = "git commit";
        dev = "nix develop --command $SHELL";
      };
      history = {
        size = 1000;
        save = 1000;
        expireDuplicatesFirst = true;
      };
      plugins = [
        {
          name = "zsh-powerlevel10k";
          src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
          file = "powerlevel10k.zsh-theme";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];
      initExtra = ''
                source "$HOME/.p10k.zsh"
        	eval "$(direnv hook zsh)"
      '';
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };
  };
  wayland = {
    windowManager.sway = {
      enable = true;
      config = null;
      extraConfig = builtins.readFile ./cfg/sway/config;
    };
  };
  xdg.configFile = {
    "nix/nix.conf" = {
      text = ''
        experimental-features = nix-command flakes
      '';
    };
    "user-dirs.dirs" = {
      source = pkgs.writeText "user-dirs.dirs" ''
        XDG_DESKTOP_DIR="dt"
        XDG_DOCUMENTS_DIR="doc"
        XDG_DOWNLOAD_DIR="dl"
        XDG_MUSIC_DIR="snd"
        XDG_PICTURES_DIR="pic"
        XDG_PUBLICSHARE_DIR="pub"
        XDG_TEMPLATES_DIR="tp"
        XDG_VIDEOS_DIR="vid"
      '';
    };
  };
  services = {
    emacs = {
      enable = true;
    };
  };
}
