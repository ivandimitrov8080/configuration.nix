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
          };
        };
        devShells.default = pkgs.mkShell {
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
      };
    };
}
