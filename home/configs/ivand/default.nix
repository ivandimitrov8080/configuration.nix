toplevel@{ inputs, withSystem, config, ... }:
{
  flake.homeConfigurations.ivand = withSystem "x86_64-linux" (ctx@{ pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        let
          mods = config.flake.homeManagerModules;
        in
        [
          {
            home.stateVersion = config.flake.stateVersion;
          }
          inputs.nid.hmModules.nix-index
          inputs.catppuccin.homeManagerModules.catppuccin
          mods.all
          mods.dev
          mods.essential
          mods.random
          mods.reminders
        ];
    });
}
