top@{ inputs, ... }: {
  imports = [ ./nixos ./home ./packages ./overlays ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "24.05";
  perSystem = perSystem@{ system, ... }: {
    config._module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          top.config.flake.overlays.default
        ];
      };
    };
  };
}
