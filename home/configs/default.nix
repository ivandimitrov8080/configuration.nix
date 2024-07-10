toplevel@{ inputs, withSystem, config, ... }:
{
  flake.homeConfigurations.ivand = withSystem "x86_64-linux" (ctx@{ pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        let
          mods = config.flake.homeManagerModules;
        in
        with mods; [
          base
          ivand
          shell
          util
          swayland
          web
          work
        ];
    });
}
