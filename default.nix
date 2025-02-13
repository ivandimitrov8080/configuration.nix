{ inputs, ... }:
{
  imports = [ ./src ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "24.11";
  perSystem =
    {
      system,
      pkgs,
      config,
      ...
    }:
    {
      config = {
        _module.args = {
          pkgs = import inputs.nixpkgs-unstable { inherit system; };
        };
        treefmt = {
          programs = {
            nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
            };
            biome.enable = true;
            shfmt.enable = true;
          };
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (ghc.withPackages (hkgs: with hkgs; [ turtle ]))
            (config.packages.nvim.extend {
              plugins = {
                lsp.servers = {
                  hls = {
                    enable = true;
                    installGhc = false;
                  };
                };
              };
            })
          ];
        };
      };
    };
}
