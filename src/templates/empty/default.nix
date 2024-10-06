{ inputs, ... }: {
  systems = [ "x86_64-linux" ];
  perSystem = { system, pkgs, ... }: {
    config._module.args = {
      pkgs = import inputs.configuration.inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.configuration.overlays.default
        ];
      };
    };
    config.devShells.default = pkgs.mkShell { };
    config.packages.default = pkgs.stdenv.mkDerivation { };
  };
}
