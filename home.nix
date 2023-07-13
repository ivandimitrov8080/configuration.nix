{
  pkgs,
  lib,
  ...
}: {
  home = {
    username = "ivand";
    homeDirectory = "/home/ivand";
    stateVersion = "23.05";
    sessionPath = ["$HOME/.local/bin/" "$HOME/.local/share/pnpm"];
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
      extraPackages = with pkgs; [
        alejandra
        lua-language-server
        libclang
        rnix-lsp
      ];
      plugins = with pkgs.vimPlugins; [
        nvim-cmp
        nvim-treesitter.withAllGrammars
        nvim-tree-lua
        telescope-nvim
        catppuccin-nvim
      ];
      extraLuaConfig = ''
        require("nvim-tree").setup()
        vim.cmd.colorscheme "catppuccin"
      '';
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
      ];
      initExtra = ''
        source "$HOME/.p10k.zsh"
      '';
    };
  };
  xdg.configFile = {
    "nvim/lua/custom" = {
      source = ./cfg/nvim/custom;
      recursive = true;
    };
    "sway/config" = {
      source = ./cfg/sway/config;
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
}
