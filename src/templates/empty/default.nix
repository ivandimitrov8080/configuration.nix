{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];
  perSystem =
    { system, pkgs, ... }:
    {
      config = {
        _module.args = {
          pkgs = import inputs.configuration.inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.configuration.overlays.default
            ];
          };
          devShells.default = pkgs.mkShell { };
          packages.default = pkgs.stdenv.mkDerivation { };
        };
      };
    };
}
