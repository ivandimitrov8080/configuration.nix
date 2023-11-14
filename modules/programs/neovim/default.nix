{ pkgs, lib, config, ... }:
let
  grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    diff
    regex
    vimdoc
    comment
    markdown
    ungrammar
    gitignore
    gitcommit
    git_rebase
    git_config
    gitattributes
    dockerfile
  ];
  cfg = config.programs.nv;
in
{
  imports = [ ./firenvim.nix ./py.nix ./hs.nix ./bash.nix ./nix.nix ./lua.nix ./js.nix ./util.nix ];

  options.programs.nv = {
    enable = lib.mkEnableOption "nv";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      extraPackages = with pkgs; [
        ripgrep
      ];
      plugins = with pkgs.vimPlugins; grammars ++ [
        nvim-treesitter
        nvim-surround
        nvim-ts-autotag
        autoclose-nvim
        barbar-nvim
        cmp-nvim-lsp
        comment-nvim
        gitsigns-nvim
        luasnip
        catppuccin-nvim
        nvim-cmp
        nvim-lspconfig
        nvim-web-devicons
        plenary-nvim
        telescope-nvim
        toggleterm-nvim
        vim-vinegar
        lualine-nvim
      ];
      extraLuaConfig = lib.fileContents ./nvim/default.lua;
    };
  };
}
