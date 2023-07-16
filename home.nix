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
      extraConfig = ''
                set -g default-command "''${SHELL}"
        	set -g default-terminal "tmux-256color"
      '';
    };
    neovim = {
      enable = true;
      viAlias = true;
      extraPackages = with pkgs; [
        go
        gopls
        nodePackages_latest.prettier
        nodePackages_latest.typescript
        nodePackages_latest.typescript-language-server
        alejandra
        libclang
        lua
        lua-language-server
        python311Packages.python-lsp-black
        python311Packages.python-lsp-server
        ripgrep
        rnix-lsp
        stylua
      ];
      plugins = with pkgs.vimPlugins; [
	toggleterm-nvim
        autoclose-nvim
        barbar-nvim
        cmp-nvim-lsp
        luasnip
        nightfox-nvim
        nvim-cmp
        nvim-cmp
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        nvim-web-devicons
        plenary-nvim
        telescope-nvim
        telescope-nvim
        vim-vinegar
      ];
      extraLuaConfig = lib.fileContents ./cfg/nvim/init.lua;
    };
    zsh = {
      enable = true;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      completionInit = '''';
      history = {
        size = 1000;
        save = 1000;
        expireDuplicatesFirst = true;
      };
      plugins = [
        {
          name = "zsh-autoenv";
          src = "${pkgs.zsh-autoenv}/share/zsh-autoenv";
          file = "autoenv.plugin.zsh";
        }
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
        {
          name = "zsh-you-should-use";
          file = "you-should-use.plugin.zsh";
          src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
        }
      ];
      initExtra = ''
        source "$HOME/.p10k.zsh"
      '';
    };
  };
  xdg.configFile = {
    "sway/config" = {
      source = ./cfg/sway/config;
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
}
