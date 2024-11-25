top@{ inputs, ... }:
{
  imports = [ ./src ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "24.11";
  perSystem =
    { system, ... }:
    {
      config._module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            top.config.flake.overlays.default
            inputs.neovim-nightly-overlay.overlays.default
          ];
        };
      };
    };
}
