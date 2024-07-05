top@{ inputs, ... }: {
  imports = [ ./nixos ./home ./packages ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "24.05";
  perSystem = perSystem@{ config, system, ... }: {
    config._module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            nvim = config.packages.nvim;
            bingwp = config.packages.bingwp;
            screenshot = config.packages.screenshot;
          })
          inputs.sal.overlays.default
        ];
      };
    };
  };
}
