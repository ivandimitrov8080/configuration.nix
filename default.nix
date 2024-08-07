top @ { inputs, ... }: {
  imports = [ ./nixos ./home ./packages ./overlays ./hardware-configurations ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "24.05";
  perSystem = { system, ... }: {
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
