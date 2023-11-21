{ system, pkgs, home-manager, modules, ... }:
with modules.home;
{
  ivand = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = with programs; [ ./ivand packages nvim zsh tmux git chromium kitty lf obs-studio sway swaylock browserpass ];
  };
  vid = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = with programs; [ ./vid nvim zsh tmux ];
  };
}
