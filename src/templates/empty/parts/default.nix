{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];
  perSystem =
    { system, pkgs, ... }:
    {
      config = {
        _module.args = {
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.configuration.overlays.default
              (_final: prev: {
                nvim = prev.nvim.extend {
                  plugins = {
                    lsp.servers = {
                      # pylsp.enable = true;
                      # svelte.enable = true;
                      # html.enable = true;
                      # ts_ls.enable = true;
                      # jsonls.enable = true;
                      # tailwindcss.enable = true;
                      # cssls.enable = true;
                      # rust_analyzer = {
                      #   installCargo = false;
                      #   installRustc = false;
                      # };
                      # rustaceanvim = {
                      #   enable = true;
                      # };
                    };
                  };
                };
              })
            ];
          };
        };
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nvim
            ];
          };
        };
        packages = {
          default = pkgs.stdenv.mkDerivation { };
        };
      };
    };
}
