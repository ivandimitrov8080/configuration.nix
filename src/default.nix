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
            shellHook = "exec ${pkgs.zsh}/bin/zsh";
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
            shellHook = "exec ${pkgs.zsh}/bin/zsh";
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
        };
      };
    };
}
