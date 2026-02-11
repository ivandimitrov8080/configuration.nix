{
  nixvim,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) recurseIntoAttrs;
in
recurseIntoAttrs rec {
  default = nixvim;
  main = nixvim.extend (import ./default-nixvim-config.nix pkgs);
  java = import ./java { inherit main lib pkgs; };
  c = main.extend { lsp.servers.ccls.enable = true; };
  haskell = main.extend {
    lsp.servers.hls.enable = true;
  };
  lean = main.extend {
    plugins.lean = {
      enable = true;
      settings = {
        abbreviations = {
          enable = true;
          extra = {
            wknight = "♘";
          };
        };
        ft = {
          default = "lean";
          nomodifiable = [
            "_target"
          ];
        };
        infoview = {
          autoopen = true;
          horizontal_position = "top";
          indicators = "always";
          separate_tab = false;
        };
        lsp = {
          enable = true;
        };
        mappings = false;
        progress_bars = {
          enable = false;
        };
        stderr = {
          enable = true;
          on_lines = {
            __raw = "function(lines) vim.notify(lines) end";
          };
        };
      };
    };
  };
  scala = main.extend {
    lsp.servers.metals.enable = true;
  };
  rust = main.extend {
    plugins.rustaceanvim.enable = true;
    lsp.servers.tombi.enable = true;
  };
  web = main.extend {
    lsp.servers = {
      ts_ls.enable = true;
      svelte.enable = true;
      html.enable = true;
      cssls.enable = true;
      jsonls.enable = true;
      tailwindcss.enable = true;
    };
  };
  python = main.extend {
    plugins.lsp.servers.pylsp = {
      enable = true;
      settings = {
        plugins = {
          rope.enabled = true;
          rope_autoimport.enabled = true;
          rope_autoimport.memory = true;
          rope_copletion.enabled = true;
          black.enabled = true;
        };
      };
    };
  };
  lua = main.extend {
    lsp.servers.emmylua_ls.enable = true;
  };
}
