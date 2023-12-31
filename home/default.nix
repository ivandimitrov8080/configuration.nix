{ system, pkgs, home-manager, modules, nid, ... }:
let
  ivand-programs = with modules.home.programs; [ nvim zsh tmux git chromium firefox kitty lf obs-studio sway swaylock browserpass bottom gpg comma ];
  ivand-packages = with modules.home.packages; [ dev essential media ];
  vid-programs = with modules.home.programs; [ nvim zsh tmux ];
in
{
  ivand = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ ./ivand nid.hmModules.nix-index ] ++ ivand-programs ++ ivand-packages;
  };
  vid = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ ./vid ] ++ vid-programs;
  };
}
