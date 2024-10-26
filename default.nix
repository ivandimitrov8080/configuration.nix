toplevel@{ inputs, ... }: {
  imports = [ ./src ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "24.05";
  perSystem = { system, ... }: {
    config._module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-unwrapped"
          "steam-run"
        ];
        overlays = [
          toplevel.config.flake.overlays.default
          inputs.neovim-nightly-overlay.overlays.default
        ];
      };
    };
  };
}
