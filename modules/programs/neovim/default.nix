{ nvim, ... }:
nvim
{
  enable = true;
  plugins.lsp.servers = {
    bashls.enable = true;
  };
}
