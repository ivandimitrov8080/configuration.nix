{ pkgs, lib, ... }:

let grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
];
in
{
  programs.neovim = {
    extraPackages = with pkgs; [

    ];
    plugins = with pkgs.vimPlugins; grammars ++ [
      firenvim
    ];
    extraLuaConfig = ''
      vim.g.firenvim_config = {
          globalSettings = { alt = "all" },
          localSettings = {
              [".*"] = {
                  cmdline  = "neovim",
                  content  = "text",
                  priority = 0,
                  selector = "textarea",
                  takeover = "never"
              }
          }
      }
    '';
  };
}
