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
          };
        };
        devShells.default = pkgs.mkShell { };
        packages.default = pkgs.stdenv.mkDerivation { };
      };
    };
}
