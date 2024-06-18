toplevel@{ inputs, withSystem, ... }:
{
  flake.homeConfigurations.ivand = withSystem "x86_64-linux" (ctx@{ pkgs, stateVersion, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        let
          mods = toplevel.config.flake.homeManagerModules;
        in
        [
          {
            home.stateVersion = stateVersion;
          }
          inputs.nid.hmModules.nix-index
          mods.all
          mods.dev
          mods.essential
          mods.random
          inputs.catppuccin.homeManagerModules.catppuccin
        ];
    });
}
