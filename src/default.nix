{ inputs, ... }:
{
  imports = [
    ./modules/nixos
    ./modules/home
    ./configs/nixos.nix
    ./packages
    ./overlays
    ./constants
    ./templates
  ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "25.05";
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
          pkgs = import inputs.nixpkgs { inherit system; };
        };
        treefmt = {
          programs = {
            nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
            };
          };
        };
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              (config.packages.nvim.extend {
                plugins = {
                  lsp.servers = {
                    nushell.enable = true;
                  };
                };
              })
            ];
          };
          py = pkgs.mkShell {
            buildInputs = with pkgs; [
              (config.packages.nvim.extend {
                plugins = {
                  lsp.servers = {
                    pylsp.enable = true;
                  };
                };
              })
              python3
            ];
          };
          node = pkgs.mkShell {
            buildInputs = with pkgs; [
              (config.packages.nvim.extend {
                plugins = {
                  lsp.servers = {
                    ts_ls.enable = true;
                  };
                };
              })
              nodejs
            ];
          };
          web = pkgs.mkShell {
            buildInputs = with pkgs; [
              (config.packages.nvim.extend {
                plugins = {
                  lsp.servers = {
                    ts_ls.enable = true;
                    html.enable = true;
                    cssls.enable = true;
                    jsonls.enable = true;
                  };
                };
              })
              nodejs
            ];
          };
          rust = pkgs.mkShell {
            buildInputs = with pkgs; [
              rustc
              rust-analyzer
              rustfmt
              cargo
              pkg-config
              (config.packages.nvim.extend {
                plugins = {
                  lsp.servers = {
                    rust_analyzer = {
                      installCargo = false;
                      installRustc = false;
                    };
                  };
                  rustaceanvim = {
                    enable = true;
                  };
                };
              })
            ];
          };
          lila = pkgs.mkShell {
            buildInputs = with pkgs; [
              zulu
              coursier
              sbt
              nodejs
              pnpm
              mongodb
              mongosh
              redis
              (config.packages.nvim.extend {
                plugins = {
                  lsp.servers = {
                    metals.enable = true;
                    ts_ls.enable = true;
                  };
                };
              })
            ];
          };
        };
      };
    };
}
