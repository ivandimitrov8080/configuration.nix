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
    plugins.haskell-scope-highlighting.enable = true;
  };
  scala = main.extend {
    lsp.servers.metals.enable = true;
  };
  rust = main.extend {
    plugins.rustaceanvim.enable = true;
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
    lsp.servers.pylsp.enable = true;
  };
  lua = main.extend {
    lsp.servers.emmylua_ls.enable = true;
  };
}
